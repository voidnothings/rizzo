require 'avocado/translator'

class Avocado
  def self.hi(language = :english)
    translator = Translator.new(language)
    translator.hi
  end
end

