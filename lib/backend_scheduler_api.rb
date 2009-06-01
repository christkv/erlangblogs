require 'rubygems'
gem 'rufus-scheduler'
require 'rufus/scheduler'

class BackendSchedulerApi
  attr_accessor :tasks
  attr_accessor :scheduler
  # Scheduler job variables
  attr_accessor :task_test_job_id
  attr_accessor :job_ids_by_task

  ##
  ##  Initialize the system to correctly use logs etc
  ##
  def initialize(testing_frequency = "60m")
    # Set up the tasks
    @job_ids_by_task = {}
    @tasks_by_job_ids = {}
    # Start the scheduler
    @scheduler = Rufus::Scheduler.start_new
    # Create a logger
    @logger = Logger.new( 'scheduler.log', 'monthly' )
    @task_test_results_logger = Logger.new( 'task_test_results.log', 'monthly' )
    puts "Schedule tests"
    # Add the test runninng scheduler method
    @scheduler.every(testing_frequency) do
      test_results = execute_task_tests()
      test_results.each {|test_result|
        # the test is not nil then we have an error (print this error to the log)
        if(!test_result.nil?)
          @task_test_results_logger.error(test_result.inspect)
        end
      }
    end
  end

  ##
  ##  Add a task to the scheduler
  ##
  def add_task(task, scheduled_time = "5m")
    if task.respond_to?(:execute)
      # Add scheduled tasks
      job_id = @scheduler.every(scheduled_time) do
        task.execute()
      end
      # Save the job ide with a reference to the invoking task (using the task as a key)
      if @job_ids_by_task[task].nil? then @job_ids_by_task[task] = [] end
      # Add the job id to this task and reversed
      @job_ids_by_task[task] << job_id
      @tasks_by_job_ids[job_id] = task
    end
  end

  ##
  ##  Remove a full task type from the scheduler
  ##
  def remove_task(task)
    if task.respond_to?(:execute)
      # Clean up all the references to the task
      if !@job_ids_by_task[task].nil?
        # Remove by job_id refrences for tasks
        @job_ids_by_task[task].each {|job_id|
          @tasks_by_job_ids.delete(job_id)
          # Remove the task from the scheduler
          @scheduler.unschedule(job_id)
        }
        # Delete all the entries remaining
        @tasks_by_job_ids.delete(task)
      end
    end
  end

  ##
  ##  Remove a job by job_id
  ##
  def remove_job(job_id)
    # Remove the task from the scheduler
    if !@tasks_by_job_ids[job_id].nil?
      # Unschedule the job
      @scheduler.unschedule(job_id)
      # Fetch the used task
      task = @tasks_by_job_ids[job_id]
      # Remove the reference
      @tasks_by_job_ids.delete(job_id)
      # Find the reference in the task list
      if !@job_ids_by_task[task].nil?
        @job_ids_by_task[task].delete(job_id)
      end
    end
  end

  ##
  ##  Execute the tests on each task (to validate that everything is working great)
  ##
  def execute_task_tests
    # Run all tasks tests (ensuring we capture any changes in the sites we are monitoring)
    test_results = @tasks_by_job_ids.values.map {|task|
      puts "- Running test for task: #{task.class.name}"      
      if task.respond_to?(:test)
        begin
          result = task.test()
          if result.kind_of?(Array) && result.length > 0
            # Log the error for the result
            @task_test_results_logger.error("FAILURE:#{result.inspect}")
            # Send an email with the failure information
            Notifier.deliver_crawler_error("christkv@gmail.com", task.class.name, result)
          end
        rescue Exception => e
          # Log the error for the result
          @task_test_results_logger.error("ERROR:#{e.backtrace}")
          # Send an email with the failure information
          Notifier.deliver_crawler_error("christkv@gmail.com", task.class.name, [e.backtrace.inspect])
        end
      end
    }
    # return the test results
    return test_results
  end

  ##
  ##  Freeze until the scheduler is done running
  ##
  def join()
    @scheduler.join
  end
end