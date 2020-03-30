module AidviceExceptions
	class AidviceException < StandardError; end
	class BadParameters < AidviceException; end
	class UnauthorizedOperation < AidviceException; end
end