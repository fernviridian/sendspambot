require 'cinch'

#i am spambot
#hello

def msguser(m, who, text)
    User(who).send text
end

def sanitize_input(string)
   safe_string = string.gsub(/[^a-z,-. " ", A-Z, 1-9, .]/, '')
   safe_string.untaint
   return safe_string
end

def blacklist(user)
   if (user.include? "nibalizer" or user.include? "zortbot")
      m.reply "Please do not talk to me, #{user}."
      return true #on the blacklist dont respond
   end
  return false
end

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.server"
    c.nick = "spambotnick"
    c.ssl.use = true
    c.port = 6697
    c.realname = "I AM SPAMBOT"
    c.channels = ["#channel channelkey"]
  end

  on :message, /^!breaklock (.+)/ do |m, breaklock|
    breaklock = sanitize_input(breaklock)
    #User(who).send text
      #check if blacklist
     unless blacklist(m.user.nick)
     deruser = m.user.nick
      msg = ''
	#run the bash script
      IO.popen "bash breaklock.bash #{breaklock}" do |fd|
        until fd.eof?
         msg += "#{fd.readline}"
        end
      end
      m.reply "Instructions have been privmsg'd to you, #{m.user.nick}"
      deruser = bot.user_list.find(deruser)
      deruser.msg(msg) unless deruser.nil?
    end
  end

  on :message, /^!runaway (.+)/ do |m, runaway|
    #User(who).send text
    unless blacklist(m.user.nick)
    deruser = m.user.nick
    runaway = sanitize_input(runaway)
      msg = ''
	#run the bash script
      IO.popen "bash runaway.bash #{runaway}" do |fd|
        until fd.eof?
         msg += "#{fd.readline}"
        end
      end
    m.reply "Instructions have been privmsg'd to you, #{m.user.nick}"
    deruser = bot.user_list.find(deruser)
    deruser.msg(msg) unless deruser.nil?
   end
  end

  on :message, /^!help spambot/ do |m|
    m.reply "See !breaklock -h and !runaway -h"
  end
  
  on :message, /^!spam (.+)/ do |m, user|
    user = sanitize_input(user)
      unless blacklist(m.user.nick)
      msg = ''
      IO.popen "cat spam.txt" do |fd|
        until fd.eof?
         msg += "#{fd.readline}"
        end
      end
      deruser = bot.user_list.find(user)
      deruser.msg(msg) unless deruser.nil?
    end
  end

end

bot.start
