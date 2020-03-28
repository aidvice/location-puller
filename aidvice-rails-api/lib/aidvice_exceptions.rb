module AidviceExceptions
	class AidviceException < StandardError; end
	class BadParameters < AidviceException; end
end