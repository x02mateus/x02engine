package backend;

class Ratings {
    public static function accuracytoString(acc:Float):String {
        var accuracyFormatted:String = null;
        var accuracyRating:String = null;

		var tempMult:Float = 1;
		for (i in 0...2)
			tempMult *= 10;

		var newValue:Float = Math.floor((acc * 100) * tempMult);
        accuracyRating = getRating(newValue);
		accuracyFormatted = Std.string(newValue / tempMult);

        return '[ - Precisão: ${accuracyFormatted}% (${accuracyRating}) - ]';
    }

    private static function getRating(acc:Float):String {
        switch (acc) {
            case 0.2:   return 'horrível!';
            case 0.4:   return 'merda!';
            case 0.5:   return 'ruim';
            case 0.6:   return 'bruh';
            case 0.69:  return 'meh';
            case 0.7:   return 'boa!';
            case 0.8:   return 'bom';
            case 0.9:   return 'legal!';
            case 1:     return 'DEUS GAMER';
        }

        return '(N/A)';
    }
}