ALPHABET = "abcdefghijklmnopqrstuvwxyz"
CAESAR = ALPHABET * 2 + ALPHABET.upcase * 2

def caesar(string, distort)
    string.split("").reduce("") do |caesar_string, letter|
        CAESAR.include?(letter) ? caesar_string + CAESAR[CAESAR.index(letter) + distort] : caesar_string + letter
    end
end

print caesar("What a string!", 5)