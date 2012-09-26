# -*- coding: utf-8; -*-
#
# helpers/init.rb : initialize helper
#
# Copyright (C) 2012 by The wasam@s production
# https://github.com/tdtds/massr
#
# Distributed under GPL
#
require 'mail'

module Massr
	class App < Sinatra::Base
		helpers do
			def csrf_meta
				{:name => "_csrf", :content => Rack::Csrf.token(env)}
			end

			def csrf_input
				{:type => 'hidden', :name => '_csrf', :value => Rack::Csrf.token(env)}
			end

			def current_user
				@current_user || (@current_user = User.find_by_id(session[:user_id]))
			end

			def send_mail(user, statement)
				msg = <<-MAIL
					#{user.name}さんからレスがありました:

					「#{statement.body}」
				MAIL

				Thread.start do
					begin
						Mail.deliver do
							from 'no-replay@tdtds.jp'
							to  user.email
							subject 'Message from Massr'
							content_type 'text/plain; charset=UTF-8'
							body msg.gsub(/^\t+/, '')
						end
					rescue => e
						p e
					end
				end
			end
		end
	end
end

require_relative 'resource'
