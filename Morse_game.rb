require "path/to/alle_woorden.rb"

include Words
require 'curses'

input=""
rawinput=""
rawtime=[]
c=0
time=   [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
count=  [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
line_c=0
inter_c=0
time0=0
time1=0
lettertimes=""

File.open("path/to/Letter_graph.txt","r+") do |data|
        for line in data.readlines()
              
                if line_c==0
                        line.tr("[]","")
                        if line.index(",")!=nil
                                line.split(",").each do |z|
                                        count[inter_c]=z.to_i
                                        inter_c+=1
                                end
                        end
                end
                
                if line_c==1
                        line.tr("[]","")
                        if line.index(",")!=nil
                                line.split(",").each do |z|
                                        time[inter_c]=z.to_i
                                        inter_c+=1
                               end
                        end
                end

                line_c+=1
                inter_c=0
        end
end


loadtime_a=0
loadtime_b=0
loadtime_a=Time.now
length=Words.Dictionary.length
random=rand(length)
dictionary=Words.Dictionary
morsedictionary=Words.MorseDictionary
response=""
ask=morsedictionary[random]
answer=dictionary[random]
loadtime_b=Time.now
yes_no=""
begintime=0
endtime=0

input=0

racenumber=0
morselength=0
File.open("path/to/Races.csv","r") do |data|
        for line in data.readlines()
                racenumber+=1
        end
end


puts "Are you ready?"
pineapple=gets.chomp()


def GoSleep(time)
        sleep(time)
end




while response !="n"
        puts "\nrace starts in 2 seconds"
        sleep(1)
        puts "race starts in 1 second"
        sleep(1)
        
        
        
        Curses.init_screen
        begin
                Curses.addstr("The word you have to translate is: \n")
                Curses.addstr("#{ask[1..ask.length]} \n")
                begintime=Time.now

                while rawinput.index(answer.downcase)==nil

                        time0=(Time.now.to_f*1000)

                        input = Curses.getch

                        unless input.ord<97 || input.ord>122
                                rawinput+=input
                                time1=(Time.now.to_f*1000)
                                rawtime<<(time1-time0)
                        end

                        if input.ord==8 && rawinput.length>0
                                rawinput[rawinput.length-1]=""
                        end

                        if response=="n"
                                break;
                        end
                end



                endtime=Time.now
                unless rawinput.length != answer.length
                        while c<answer.length
                                time[rawinput[rawinput.length-1-c].ord-96] = (time[rawinput[rawinput.length-1-c].ord-96]*count[rawinput[rawinput.length-1-c].ord-96] + rawtime[rawtime.length-1-c])/(count[rawinput[rawinput.length-1-c].ord-96]+1)
                                count[rawinput[rawinput.length-1-c].ord-96] +=1
                                c+=1
                        end
                end
                c=0

                line_c=0
                File.open("path/to/Letter_graph.txt","w") do |data|
                        data.puts count.to_s
                        data.puts time.to_s
                end



                File.open("path/to/Races.csv","a") do |data|
                        data.puts "#{racenumber},#{(answer.length.to_f/5)/( (endtime.to_f-begintime.to_f)/60 ).round(3)},#{answer},#{answer.length},#{begintime},#{ask[1..ask.length].length}"
                        racenumber+=1
                end

                Curses.addstr("\nHet duurde #{(endtime.to_f)-(begintime.to_f)} seconden \n")
                Curses.addstr("Dat is #{answer.length/(endtime.to_f-begintime.to_f)} tekens per seconde \n") 
                Curses.addstr("De dat is #{(answer.length.to_f/5)/( (endtime.to_f-begintime.to_f)/60 )} WPM \n")
                Curses.addstr("De tijd om het bestand te laden was: #{loadtime_b.to_f-loadtime_a.to_f} seconden \n")

                #only in cases where the final string is exactly the same as the requested answer
                if answer.length == rawinput.length
                        while c<answer.length
                                lettertimes+="[#{answer[c]}|#{rawtime[c]}ms] "
                                c+=1
                        end
                        Curses.addstr("#{lettertimes} \n")
                        c=0
                        lettertimes=""
                end
                
                

                if racenumber%100==1
                        Curses.addstr("You have raced #{racenumber-1} times! \n") 
                end

                Curses.addstr("wanna race again? \n")

                while yes_no.index("y")==nil
                        input=Curses.getch
                        if input.ord==13 || input.ord==10
                                yes_no+="y"
                        end
                        unless input.ord<97 || input.ord>122 || input.ord==13 || input.ord==10 || input.ord==8
                                yes_no+=input.downcase
                        end

                        if yes_no.index("y")!=nil
                                loadtime_a=Time.now
                                random=rand(length)
                                ask=morsedictionary[random]
                                answer=dictionary[random]
                                loadtime_b=Time.now
                                Curses.clear
                        end
                end
                yes_no=""
                rawinput=""
                rawtime=[]
                ensure
                Curses.close_screen
        end
end
puts length
