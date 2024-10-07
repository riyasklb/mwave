// localization.dart
class Localization {
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'question1': 'How much money you invest in Money Wave?',
      'optionA': 'A. 200',
      'optionB': 'B. 100',
      'optionC': 'C. 300',
      'question2': 'What are the promises and policies maintained in Money Wave?',
      'optionD': 'A. Not refundable once you pay',
      'optionE': 'B. You pay 100₹ if you cannot earn in Money Wave, refund your money in 100 days',
      'question3': 'What all are the payment methods in Money Wave?',
      'optionF': 'A. UPI',
      'optionG': 'B. Netbank',
      'optionH': 'C. Cash',
      'question4': 'What should you do after paying 100 rupees to participate in the referral program?',
      'optionI': 'A. Refer 2 persons to get 300',
      'optionJ': 'B. Refer 2 persons your friends and family, you get 100 rupees ',
      'optionK': 'C. Refer 2 persons to get 1000',
      'question5': 'What happens after you add someone to the app and they add others?',
      'optionL': 'A. You earn ₹30 every time the third person in your referral chain joins the app',
      'optionM': 'B.You earn ₹10 every time the third person in your referral chain joins the app ',
      'optionN': 'C. You earn ₹100 every time the third person in your referral chain joins the app',
    },
    'ta': {
      'question1': 'நீங்கள் மனி வேவ் திட்டத்தில் எவ்வளவு பணத்தை முதலீடு செய்கிறீர்கள்?',
      'optionA': 'A. 200',
      'optionB': 'B. 100',
      'optionC': 'C. 300',
      'question2': 'மனி வேவ் திட்டத்தில் ஏற்றுக்கொள்ளப்படும் வாக்குறுதிகள் மற்றும் கொள்கைகள் என்ன?',
      'optionD': 'A. ஒருமுறை பணம் செலுத்திய பிறகு, அது திருப்பி அளிக்கப்படாது.',
      'optionE': 'B. நீங்கள் ₹100 செலுத்தினால், 100 நாட்களில் உங்கள் பணத்தைத் திரும்பப் பெறலாம்.',
      'question3': 'மனி வேவ் திட்டத்தில் எவ்வாறு பணம் செலுத்தலாம்?',
      'optionF': 'A. UPI',
      'optionG': 'B. நெட்பேங்கிங்',
      'optionH': 'C. ரொக்கம்',
      'question4': 'பரிந்துரை திட்டத்தில் பங்கேற்க ₹100 செலுத்திய பிறகு நீங்கள் என்ன செய்ய வேண்டும்?',
      'optionI': 'A. 2 பேருக்கு பரிந்துரை செய்யும் போது ₹300 பெறுவீர்கள்.',
      'optionJ': 'B. உங்கள் நண்பர்கள் மற்றும் குடும்பத்தினருக்கு 2 பேரை பரிந்துரை செய்யுங்கள், ₹100 பெறுவீர்கள். ',
      'optionK': 'C. 2 பேருக்கு பரிந்துரை செய்யும் போது ₹1000 பெறுவீர்கள்.',
      'question5': 'நீங்கள் ஒருவரை ஆப் உள்படுத்திய பிறகு, அவர்கள் பிறரை சேர்க்குமா?',
      'optionL': 'A. ₹30 சம்பாதிக்கிறீர்கள். ',
      'optionM': 'B. ₹10 சம்பாதிக்கிறீர்கள்.',
      'optionN': 'C. ₹100 சம்பாதிக்கிறீர்கள்.',
    },
  };

  static String getString(String key, String languageCode) {
    return _localizedValues[languageCode]?[key] ?? _localizedValues['en']![key]!;
  }
}
