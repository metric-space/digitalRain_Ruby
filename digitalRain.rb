require 'curses'
require 'agent'
require './helperFunctions'

Curses.noecho
Curses.init_screen


$height    = Curses.lines
$width     = Curses.cols
$win       = Curses::Window.new($height,$width,0,0)
MaxLength  = $height.to_i/2
MinLength  = $height.to_i/6
Sleep_time = 1.0/7.0

log = File.open("log.txt","w")

$signalToKillEverything  = 0
$globalChannel =  Agent::channel!(Integer);


def refreshAndSleep
    $win.refresh
    sleep(Sleep_time)
end

def makeRainDrop
    Agent::go! do
        e = Helper.fallingPieceGenerator(rand($width),rand(1..$height),MinLength,MaxLength)
        incr = rand(1..5)
	begin
            while 1
		e.select {|x| x[:y] >= 0 && x[:y] <= $height}
		 .each {|x| 
			 $win.setpos(x[:y],x[:x]);
			 $win.addstr(x[:piece]);
		 }
		refreshAndSleep	
		e.each {|x| 
		    $win.setpos(x[:y],x[:x]);
		    $win.addstr(" ");
		    x[:y]+=incr;	
		}
		if (e.first[:y] > $height) then 
		    log.puts "droplet died"
		    $globalChannel << 1;
		    break
		end
		if ($signalToKillEverything != 0) then break end
	    end
	rescue StandardError=>e
	    log.puts "error #{e}"
 	end
    end
end


40.times do
        makeRainDrop
end

# master routine
Agent::go! do
    while 1
         if(rand(0..5) == 1) then
             log.puts "new droplet created"
             makeRainDrop
         end
	 sleep(Sleep_time)
    end
end


$win.getch
$signalToKillEverything = 1
$win.close
log.puts("closed the normal way")
log.close
