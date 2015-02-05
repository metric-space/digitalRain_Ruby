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


# -------- falling class -----------------------

class Falling
	attr_accessor :pieceArray
	
	A = Struct.new(:piece,:x,:y)

	def initialize(piece,x,y)
		@pieceArray = [A.new(piece,x,y)]
		rand(MinLength..MaxLength).times do |i|
			@pieceArray << A.new(('a'..'z').to_a.shuffle.pop,x,y-i)
		end
	end

	def cleanst
		@pieceArray.select {|x| x.y >= 0}
	end

	def to_r
		@pieceArray.to_s
	end

	def to_s
		a = []
		@pieceArray.each {|i| a << i.piece}
		a.join
	end
end


# ------------ fun begins here -------------------------

$garb       = 0

40.times do
	Thread.new do
		i = 1
		s = rand(width)
		e = Falling.new(('a'..'z').to_a.shuffle.pop,s,rand(i..height))
		incr = rand(1..5)
		begin
			while 1
				e.cleanst.each {|x| win.setpos(x.y,x.x);win.addstr(x.piece);}
				win.refresh
				sleep(Sleep_time)

				#----sweep-----
				e.pieceArray.last(incr).each do |x|
					win.setpos(x.y,x.x)
					win.addstr(" ")
				end
				win.refresh
				e.pieceArray.each do |x| 
				       	x.y = (x.y + incr)
					if x.y > height-1
						if e.pieceArray.index(x) == 0
							incr = rand(1..5)  
						end
						x.y=x.y%(height-1)  
					end
				end
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
#thread_box.each {|t| t.join }
$garb = 1
win.close
log.puts("closed the normal way")
log.close

