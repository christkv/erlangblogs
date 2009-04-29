Sortable Table
==============

Rails plugin to sort tables of ActiveRecord data.

Install
-------

    script/plugin install git@github.com:dancroak/sortable_table.git

Conventions
-----------

params[:sort] and params[:order]

Examples
--------

Use the sortable_attributes macro to list the... sortable attributes.

Then, in your index action, pass the sort_order method to your usual
order parameter for will paginate or named scope call.

    class UsersController < Admin::BaseController

		  sortable_attributes :name, :email

		  def index
		    @users = User.paginate :page => params[:page], :order => sort_order
		  end
		
		end

Time-saving Shoulda macros for your tests:

    class UsersControllerTest < ActionController::TestCase

    	context 'GET to index with sort and order params' do
		    setup do
		      5.times do |each|
			      Factory :user,
			        :name => "name #{each}",
			        :email => "email#{each}@example.com"
			    end
		    end

		    should_sort_by :name
		    should_sort_by :email
		  end
		
		end

And some sugar for your views:

    %h1 Users

		%table
		  %tr
		    = sortable_table_header 'Name', :sort => 'name'
		    = sortable_table_header 'E-mail', :sort => 'email'

		  - @users.each do |each|
		    %tr
		      %td= each.name
		      %td= each.email

Authors
-------

Dan Croak, Joe Ferris, and Boston.rb.

Copyright (c) 2008 Dan Croak, released under the MIT license
