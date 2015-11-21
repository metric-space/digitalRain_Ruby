require 'curses'

Curses.noecho
Curses.init_screen


height     = Curses.lines
width      = Curses.cols
win        = Curses::Window.new(height,width,0,0)
MaxLength  = height.to_i/2
MinLength  = height.to_i/6
Sleep_time = 1.0/7.0
# ---- log file stuff ------------------------

log = File.open("log.txt","w")


# =======  falling function ==================

def genRandomCharacter  
	rand(97..122).chr 
end
	

def fallingPieceGenerator(x,y)
	stringLength = rand(MinLength..MaxLength)

	(0..stringLength)
	 .to_a
 	 .map { genRandomCharacter }
	 .zip([x].cycle(stringLength+1),
	      [y].cycle(stringLength+1)
	         .map.with_index{|x,i| x-i }
	     )
         .map {|x| {piece: x[0], x: x[1], y: x[2]}}
end


$garb       = 0

40.times do
	Thread.new do
		e = fallingPieceGenerator(rand(width),rand(1..height))
		incr = rand(1..5)
		begin
			while 1
				# draw string
				e.each {|x| (win.setpos(x[:y],x[:x]) && win.addstr(x[:piece])) if x[:y] != 0;}
				win.refresh
				sleep(Sleep_time)
				e.each {|x| x[:y]+=incr;win.setpos(x[:y],x[:x]);win.addstr(" ");}
				win.refresh
				sleep(Sleep_time)

				#----sweep-----
				if $garb != 0 then break end
			end
			rescue StandardError=>e
					log.puts " Something weird happend and it killed the thread"
					log.puts "error #{e}"
		end
		Thread.kill
	end

end
win.getch
$garb = 1
win.close
log.puts("closed the normal way")
log.close
