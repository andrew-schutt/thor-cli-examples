 class Hello < Thor
     desc "odinson", "Prince of Asgard"
     long_desc <<-LONGDESC
        `hello:odinson` will print out a lovely message
        from Thor odinson himself.

        The usage for this command is just invocation
        using Thor.

        `thor hello:odinson`

        No additional option are available (yet!)
     LONGDESC

     method_option :verbose, desc: "display full message from thor",
                             aliases: "-v",
                             default: false,
                             type: :boolean
     method_option :family, desc: "display message for Thor family member",
                            aliases: "-f",
                            banner: "<family member name>",
                            default: "brother",
                            type: :string,
                            enum: ["Loki", "Hela", "Odin"]
     method_option :no_name, desc: "display message without Thor addressing anyone",
                             aliases: "-nn",
                             banner: "Thor addesses no one"
     def odinson(name)
         hello_to = options[:family] ? options[:family] : name
         if options[:no_name]
           puts "Hello! It is I Thor!"
         else
           if options[:verbose]
             puts "Hello #{name}. It is I Thor! Son of Odin and Prince of Asgard!"
           else
             puts "Hello #{name}. It is I Thor!"
           end
         end
     end

     desc "thor", "also Prince of Asgard"
     long_desc <<-LONGDESC
        `hello:odinson` will print out a lovely message
        from Thor odinson himself.

        The usage for this command is just invocation
        using Thor.

        `thor hello:odinson`

        hello_to will override family option if both set
     LONGDESC

     method_option :hello_to, desc: "who to say hello to",
                              aliases: "-h"
     method_option :verbose, desc: "display full message from thor",
                             aliases: "-v",
                             default: false,
                             type: :boolean
     method_option :family, desc: "display message for Thor family member",
                            aliases: "-f",
                            banner: "<family member name>",
                            default: "brother",
                            type: :string,
                            enum: ["Loki", "Hela", "Odin"]
     method_option :no_name, desc: "display message without Thor addressing anyone",
                             aliases: "-nn",
                             banner: "Thor addesses no one"
     def thor
         if option[:family]
           hello_to = options[:family]
         end
         if option[:hello_to]
           hello_to = options[:hello_to]
         end
         if options[:no_name] || !hello_to
           puts "Hello! It is I Thor!"
         else
           if options[:verbose]
             puts "Hello #{hello_to}. It is I Thor! Son of Odin and Prince of Asgard!"
           else
             puts "Hello #{hello_to}. It is I Thor!"
           end
         end
     end
 end
