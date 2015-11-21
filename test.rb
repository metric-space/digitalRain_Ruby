require 'bacon'
require './helperFunctions'

describe 'sanity check for the helper functions' do 

	it 'generateRandomCharacters should only generate lowercase characters' do
		(Helper.genRandomCharacter =~ /[a-z]/).should.equal 0
	end

	describe 'fallingPieceGenerator should generate a list of hashmaps of type (Char,Int,Int)' do
		it 'checking for the Char part of things' do
			puts Helper.fallingPieceGenerator(10,20,400,400).inspect
			Helper.fallingPieceGenerator(10,20,400,400)
			      .map {|x| x[:piece] =~ /[a-z]/}
			      .detect {|x| x == false}
			      .nil?.should.equal true
		end

	end
end

