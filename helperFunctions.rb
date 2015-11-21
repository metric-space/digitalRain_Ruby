module Helper 

	def Helper.genRandomCharacter  
		rand(97..122).chr 
	end
	

	def Helper.fallingPieceGenerator(x, y, minLength, maxLength)
		stringLength = rand(minLength..maxLength)

		(0..stringLength)
		 .to_a
		 .map { genRandomCharacter }
		 .zip([x].cycle(stringLength+1),
		      [y].cycle(stringLength+1)
			 .map.with_index{|x,i| x-i }
		     )
		 .map {|x| {piece: x[0], x: x[1], y: x[2]}}
	end


end
