require "path/to/alle_woorden.rb"

include Words


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

#can also be done by hand by adding a "Races.csv"-file with: "Racenumber,Speed,Woord,Characters,Time" in the same folder and removing line 22-26 of this program
unless File.file?("D:/Programming/Ruby Folder/Learning_Morse_Code/Races.csv")
        File.open("D:/Programming/Ruby Folder/Learning_Morse_Code/Races.csv","w") do |data|
            data.puts "Racenumber,Speed,Woord,Characters,Time"
        end
end



racenumber=0

File.open("D:/Programming/Ruby Folder/Learning_Morse_Code/Races.csv","r") do |data|
        for line in data.readlines()
        racenumber+=1
        end
end

while response !="n"
        
      puts "race starts in 2 seconds"
      sleep(1)
      puts "race starts in 1 second"
      sleep(1)

  puts "The word you have to translate is:"
  puts ask[1..ask.length] 
  begintime=Time.now

    while answer.downcase!=response.downcase
      response=gets.chomp()

      if response=="n"
        break;
      end
    end
    
    endtime=Time.now

    File.open("D:/Programming/Ruby Folder/Learning_Morse_Code/Races.csv","a") do |data|
      data.puts "#{racenumber},#{(answer.length.to_f/5)/( (endtime.to_f-begintime.to_f)/60 ).round(3)},#{answer},#{answer.length},#{begintime}"
      racenumber+=1
    end


    puts "It took #{(endtime.to_f)-(begintime.to_f)} seconds"
    puts "That's #{answer.length/(endtime.to_f-begintime.to_f)} characters per second"
    puts "That's #{(answer.length.to_f/5)/( (endtime.to_f-begintime.to_f)/60 )} WPM"
    puts "Loading time: #{loadtime_b.to_f-loadtime_a.to_f} seconds"
    
    if racenumber%100==0
        puts "You have raced #{racenumber} times!"
    end
        
        
    puts "want to try again?"
    
        
        
        
        
    yes_no=gets.chomp()
    if yes_no=="y" || yes_no="yes" || yes_no="ye" || yes_no==""
        loadtime_a=Time.now
        random=rand(length)
        ask=morsedictionary[random]
        answer=dictionary[random]
        loadtime_b=Time.now
        else response="n"
    end
end
