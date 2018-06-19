class Quinjet < Thor
  include Thor::Actions
  desc "authenticate", "authenticates for quinjet access"
  def authenticate
    authenticated = false
    run_config = {:verbose => false}
    run("say -v Moira Welcome. Authentication required.", run_config)
    while !authenticated
      username = ask "Welcome. Authentication required."
      if username.upcase == "POINT BREAK"
        authenticated = true
        run("say -v Moira Welcome Point Break.", run_config)
      else
        run("say -v Moira Access Denied.", run_config)
      end
    end
  end
end
