// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Konservatuvara Hazırlık';

  @override
  String get homePrototypeChip => 'İlk prototip';

  @override
  String get homeTitle => 'Konservatuvara Hazırlık';

  @override
  String get homeDescription =>
      'Kulak, melodi, ritim ve ses çalışmalarını tek bir yerde topla.';

  @override
  String get exerciseCategoriesTitle => 'Egzersiz Kategorileri';

  @override
  String get todayPracticeTitle => 'Bugünkü Çalışman';

  @override
  String get todayPracticePlanName => '12 dakikalık demo plan';

  @override
  String get todayPracticePlanDescription =>
      '4 dk tek ses, 4 dk portedeki notayı bul, 4 dk serbest piyano.';

  @override
  String get startPracticeButton => 'Çalışmaya Başla';

  @override
  String get productDifferenceTitle => 'Bu uygulamanın odağı';

  @override
  String get productDifferenceItemListen =>
      'Sesini dinleyerek perde doğruluğunu ölçer';

  @override
  String get productDifferenceItemPianoStaff =>
      'Aynı içeriği piyano ve portede birlikte gösterir';

  @override
  String get productDifferenceItemExam =>
      'Konservatuvar ve yetenek sınavı rutinlerine hazırlanır';

  @override
  String get settingsTitle => 'Dil ve Nota Gösterimi';

  @override
  String get settingsDescription =>
      'Arayüz dili ile nota adlandırması birbirinden bağımsız değiştirilebilir. Tercihler şimdilik yalnızca bellek içinde tutulur.';

  @override
  String get languageSettingTitle => 'Uygulama dili';

  @override
  String get languageSystemOption => 'Sistem Dilini Kullan';

  @override
  String get languageEnglishOption => 'English';

  @override
  String get languageTurkishOption => 'Türkçe';

  @override
  String get noteNamingSettingTitle => 'Nota adlandırma';

  @override
  String get noteNamingSettingDescription =>
      'Bu ayar, arayüz dilini değiştirmeden nota adlarının nasıl gösterileceğini belirler.';

  @override
  String get noteNamingFixedDoOption => 'Sabit Do';

  @override
  String get noteNamingLetterNamesOption => 'Harfli Sistem';

  @override
  String get noteNamingFixedDoDescription => 'Do, Re, Mi, Fa, Sol, La, Si';

  @override
  String get noteNamingLetterNamesDescription => 'C, D, E, F, G, A, B';

  @override
  String get activeLabel => 'Aktif';

  @override
  String get totalLabel => 'Toplam';

  @override
  String get correctLabel => 'Doğru';

  @override
  String get wrongLabel => 'Yanlış';

  @override
  String get incorrectLabel => 'Yanlış';

  @override
  String get comingSoon => 'Yakında';

  @override
  String get statusActive => 'Aktif';

  @override
  String get openTraining => 'Çalışmayı Aç';

  @override
  String get viewDetails => 'Detayı Gör';

  @override
  String get categoryExercisesTitle => 'Egzersizler';

  @override
  String get exerciseUnavailableMessage =>
      'Bu egzersiz yakında kullanıma açılacak.';

  @override
  String get backToHomeButton => 'Ana Ekrana Dön';

  @override
  String get categoryNotFoundTitle => 'Kategori Bulunamadı';

  @override
  String get categoryNotFoundMessage => 'Bu kategori şu anda tanımlı değil.';

  @override
  String get exerciseNotFoundTitle => 'Egzersiz Bulunamadı';

  @override
  String get exerciseNotFoundMessage =>
      'İstenen egzersiz şu anda tanımlı değil.';

  @override
  String durationMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dk',
      one: '1 dk',
    );
    return '$_temp0';
  }

  @override
  String questionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count soru',
      one: '1 soru',
    );
    return '$_temp0';
  }

  @override
  String availableProgress(int available, int total) {
    return '$available / $total hazır';
  }

  @override
  String get categoryHearAndSingTitle => 'Duy ve Söyle';

  @override
  String get categoryHearAndSingDescription =>
      'Duyduğunu doğru perdeyle tekrar etmeye ve ses kontrolüne odaklan.';

  @override
  String get categoryHearAndTapTitle => 'Duy ve Vur';

  @override
  String get categoryHearAndTapDescription =>
      'Ritimleri alkış, vuruş veya zamanlama araçlarıyla karşıla.';

  @override
  String get categoryHearAndWriteTitle => 'Duy ve Yaz';

  @override
  String get categoryHearAndWriteDescription =>
      'Duyduğun müziği doğru nota ve sürelerle porteye yerleştir.';

  @override
  String get categoryReadAndPerformTitle => 'Oku ve Uygula';

  @override
  String get categoryReadAndPerformDescription =>
      'Notasyonu oku, notaları tanı ve sesinle ya da piyanoyla uygula.';

  @override
  String get categoryExamSimulationTitle => 'Sınav Simülasyonu';

  @override
  String get categoryExamSimulationDescription =>
      'Gerçek değerlendirmelere daha yakın karma egzersiz akışlarıyla çalış.';

  @override
  String get categoryFreePracticeTitle => 'Serbest Çalışma';

  @override
  String get categoryFreePracticeDescription =>
      'Piyano, porte ve yardımcı araçlarla bireysel tekrar yap.';

  @override
  String get difficultyBeginner => 'Başlangıç';

  @override
  String get difficultyIntermediate => 'Orta';

  @override
  String get difficultyAdvanced => 'İleri';

  @override
  String get modeTraining => 'Eğitim';

  @override
  String get modeExam => 'Sınav';

  @override
  String get modeFreePractice => 'Serbest Çalışma';

  @override
  String get requirementMicrophone => 'Mikrofon';

  @override
  String get requirementPiano => 'Piyano';

  @override
  String get requirementStaff => 'Porte';

  @override
  String get requirementRhythmEngine => 'Ritim Motoru';

  @override
  String get requirementPitchDetection => 'Pitch Tespiti';

  @override
  String get exerciseSingleNoteTitle => 'Tek Ses Tekrarı';

  @override
  String get exerciseSingleNoteDescription =>
      'Tek bir hedef sesi duyup aynı notayı sesinle tekrar et.';

  @override
  String get exerciseTwoNoteTitle => 'Çift Ses Ayırma';

  @override
  String get exerciseTwoNoteDescription =>
      'İki sesi ayırt edip her birini ayrı ayrı duymayı çalış.';

  @override
  String get exerciseThreeNoteTitle => 'Üç Ses Ayırma';

  @override
  String get exerciseThreeNoteDescription =>
      'Üç sesli yapıları duyarak ayrı ses çizgilerini fark et.';

  @override
  String get exerciseFourNoteTitle => 'Dört Ses Ayırma';

  @override
  String get exerciseFourNoteDescription =>
      'Akor içindeki dört sesi ayrı ayrı duymaya hazırlan.';

  @override
  String get exerciseMelodyRepeatTitle => 'Melodi Tekrarı';

  @override
  String get exerciseMelodyRepeatDescription =>
      'Kısa melodileri doğru sırayla ve doğru perdeyle tekrar et.';

  @override
  String get exerciseIntervalSingingTitle => 'Aralık Söyleme';

  @override
  String get exerciseIntervalSingingDescription =>
      'Verilen başlangıç notasından hedef aralığı sesinle kur.';

  @override
  String get exerciseRhythmRepeatTitle => 'Ritim Tekrarı';

  @override
  String get exerciseRhythmRepeatDescription =>
      'Duyduğun ritmi aynı akışla geri vurmayı dene.';

  @override
  String get exerciseCompleteRhythmTitle => 'Ritmi Tamamla';

  @override
  String get exerciseCompleteRhythmDescription =>
      'Eksik bırakılan vuruşları doğru değerlerle tamamla.';

  @override
  String get exerciseFindBrokenRhythmTitle => 'Hatalı Ritmi Bul';

  @override
  String get exerciseFindBrokenRhythmDescription =>
      'Doğru örnekle hatalı ritim arasındaki farkı yakala.';

  @override
  String get exerciseClapRepeatTitle => 'Alkış Tekrarı';

  @override
  String get exerciseClapRepeatDescription =>
      'Ritmi alkışla veya vuruşla mikrofondan tekrar et.';

  @override
  String get exercisePlaceSingleNoteTitle => 'Tek Notayı Porteye Yerleştir';

  @override
  String get exercisePlaceSingleNoteDescription =>
      'Duyduğun tek notayı portede doğru yere seç.';

  @override
  String get exerciseWriteRhythmTitle => 'Ritmi Porteye Yaz';

  @override
  String get exerciseWriteRhythmDescription =>
      'Duyduğun ritmi nota süreleriyle ölçüye yerleştir.';

  @override
  String get exerciseMelodicDictationTitle => 'Melodik Dikte';

  @override
  String get exerciseMelodicDictationDescription =>
      'Duyduğun melodiyi notalar ve süreleriyle porteye yaz.';

  @override
  String get exercisePlaceChordTitle => 'Akoru Porteye Yerleştir';

  @override
  String get exercisePlaceChordDescription =>
      'Birlikte duyulan sesleri akor olarak porteye yerleştir.';

  @override
  String get exerciseNoteReadingAndWritingTitle => 'Nota Okuma ve Yazma';

  @override
  String get exerciseNoteReadingAndWritingDescription =>
      'Portede gördüğün notayı adı ve oktavıyla birlikte tanı.';

  @override
  String get exerciseSingStaffNoteTitle => 'Portedeki Notayı Söyle';

  @override
  String get exerciseSingStaffNoteDescription =>
      'Portede verilen notayı doğru perdeyle seslendirmeyi dene.';

  @override
  String get exercisePlayOnPianoTitle => 'Piyanoda Çal';

  @override
  String get exercisePlayOnPianoDescription =>
      'Portede verilen notayı ekrandaki piyanoda doğru tuşla çal.';

  @override
  String get exerciseSightSingingTitle => 'Deşifre';

  @override
  String get exerciseSightSingingDescription =>
      'Yazılı kısa pasajları önceden hazırlanmadan oku ve uygula.';

  @override
  String get exerciseSolfegeTitle => 'Solfej';

  @override
  String get exerciseSolfegeDescription =>
      'Yazılı melodiyi ritim ve perde doğruluğuyla seslendir.';

  @override
  String get exerciseExamSimulationTitle => 'Sınav Simülasyonu';

  @override
  String get exerciseExamSimulationDescription =>
      'Temel işitme ve nota görevlerini tek bir sınav akışında çöz.';

  @override
  String get exerciseIntermediateExamTitle => 'Orta Seviye Sınav Simülasyonu';

  @override
  String get exerciseIntermediateExamDescription =>
      'Daha uzun işitme ve ritim görevlerini tek bir provada birleştir.';

  @override
  String get exerciseAdvancedExamTitle => 'İleri Seviye Sınav Simülasyonu';

  @override
  String get exerciseAdvancedExamDescription =>
      'Çok sesli ve melodik görevleri tek bir ileri seviye sınav akışında topla.';

  @override
  String get exerciseCustomExamTitle => 'Özel Sınav Oluşturma';

  @override
  String get exerciseCustomExamDescription =>
      'Kendi sınav akışını veya öğretmen odaklı çalışma setini oluştur.';

  @override
  String get exerciseFreePianoTitle => 'Serbest Piyano';

  @override
  String get exerciseFreePianoDescription =>
      'Etkileşimli klavyede notaları deneyip serbest tekrar yap.';

  @override
  String get exerciseFreeStaffTitle => 'Serbest Porte';

  @override
  String get exerciseFreeStaffDescription =>
      'Porte yerleşimini puanlama olmadan incele.';

  @override
  String get exerciseMetronomeTitle => 'Metronom';

  @override
  String get exerciseMetronomeDescription =>
      'Sabit tempo ile bireysel ritim çalışması yap.';

  @override
  String get exerciseTunerTitle => 'Akort Cihazı';

  @override
  String get exerciseTunerDescription =>
      'Ses yüksekliğini anlık izleyip perde doğruluğunu kontrol et.';

  @override
  String get exerciseVocalRangeTestTitle => 'Ses Aralığı Testi';

  @override
  String get exerciseVocalRangeTestDescription =>
      'Rahat alt ve üst ses sınırını ölçmeye hazırlan.';

  @override
  String get singleNoteAppBarTitle => 'Tek Ses Tekrarı';

  @override
  String get singleNoteHeroTitle => 'Duyduğun sesi tekrar et';

  @override
  String get singleNoteHeroDescription =>
      'Önce hedef sesi dinle, sonra aynı notayı sesinle yakalamayı dene. Hedef nota adı doğrudan yazılmak yerine portede gösterilir.';

  @override
  String get targetNoteLabel => 'Hedef nota';

  @override
  String get targetNoteOnStaff => 'Porte üzerinde';

  @override
  String get targetFrequencyLabel => 'Hedef frekans';

  @override
  String get listenButton => 'Sesi Dinle';

  @override
  String get singStartButton => 'Söylemeye Başla';

  @override
  String get detectedNoteLabel => 'Algılanan nota';

  @override
  String get detectedNoteCaption => 'Şimdilik örnek veri gösteriliyor.';

  @override
  String get detectedFrequencyLabel => 'Algılanan frekans';

  @override
  String get detectedFrequencyCaption =>
      'Hedef notaya yakın örnek frekans değeri.';

  @override
  String get centDifferenceLabel => 'Cent farkı';

  @override
  String get centDifferenceCaption =>
      'Eksi değer, sesinin biraz pes kaldığını gösterir.';

  @override
  String get resultTitle => 'Sonuç';

  @override
  String get resultPanelDescription =>
      'Pes / Doğru / Tiz göstergesi gerçek analiz eklendiğinde canlı güncellenecek.';

  @override
  String get pitchFlat => 'Biraz pes';

  @override
  String get pitchCorrect => 'Doğru';

  @override
  String get pitchSharp => 'Biraz tiz';

  @override
  String get previewSoundPlayingMessage => 'Hedef ses örneği çalınıyor.';

  @override
  String previewSoundShowingMessage(Object audioStatus) {
    return 'Hedef ses gösteriliyor. $audioStatus';
  }

  @override
  String get microphonePermissionDeniedMessage =>
      'Mikrofon izni verilmedi. Bu egzersiz için önce izin vermen gerekecek.';

  @override
  String get recordPreviewMessage =>
      'Mikrofondan ses alma akışı hazır, ancak sesini notaya çeviren gerçek analiz motoru henüz eklenmedi. Şimdilik örnek sonuçlar gösteriliyor.';

  @override
  String get demoSequencePlayingMessage => 'Do-Mi-Sol demosu başlatıldı.';

  @override
  String demoSequenceShowingMessage(Object audioStatus) {
    return 'Do-Mi-Sol demosu gösteriliyor. $audioStatus';
  }

  @override
  String get pianoOpenButton => 'Piyanoyu Aç';

  @override
  String get pianoCloseButton => 'Piyanoyu Kapat';

  @override
  String get showExerciseNotesOnPiano => 'Egzersiz notalarını piyanoda göster';

  @override
  String get followHighlightByOctave => 'Vurguyu oktava göre takip et';

  @override
  String get showNoteNamesOnKeys => 'Nota adlarını göster';

  @override
  String get sustainLabel => 'Sustain';

  @override
  String get stopAllPianoButton => 'Tüm Sesleri Durdur';

  @override
  String get playA4DemoButton => 'La4 Çal';

  @override
  String get playCMajorDemoButton => 'Do Majör Çal';

  @override
  String playReferenceNoteButton(Object noteName) {
    return '$noteName Göster ve Çal';
  }

  @override
  String playMajorChordButton(Object chordName) {
    return '$chordName Göster ve Çal';
  }

  @override
  String majorChordName(Object rootName) {
    return '$rootName majör akoru';
  }

  @override
  String get developmentDemoButton => 'Do-Mi-Sol demosunu göster';

  @override
  String get previousOctave => 'Önceki Oktav';

  @override
  String get nextOctave => 'Sonraki Oktav';

  @override
  String octaveLabel(int octave) {
    return '$octave. Oktav';
  }

  @override
  String octaveRangeLabel(int startOctave, int endOctave) {
    return '$startOctave-$endOctave. Oktav';
  }

  @override
  String get lastPlayedNoteTitle => 'Son basılan nota';

  @override
  String get noNotePlayedYet => 'Henüz bir nota çalmadın';

  @override
  String lastPlayedNoteDetails(
    Object internationalName,
    int midi,
    Object frequency,
  ) {
    return 'Uluslararası adı: $internationalName • MIDI $midi • $frequency';
  }

  @override
  String get lastPlayedNoteHint =>
      'Tuşa bastığında nota adı, oktavı, MIDI numarası ve frekansı burada görünecek.';

  @override
  String get pianoSoundReady => 'Piyano sesi hazır.';

  @override
  String get invalidMidiNoteMessage =>
      'Geçerli bir MIDI nota numarası kullanılamadı.';

  @override
  String get pianoSoundFontMissingMessage =>
      'Piyano ses dosyası henüz eklenmedi.';

  @override
  String get pianoSoundFontInvalidMessage =>
      'Piyano ses dosyası bozuk veya geçersiz.';

  @override
  String get pianoEngineErrorMessage => 'Piyano sesi şu anda hazırlanamadı.';

  @override
  String get staffOpenButton => 'Porteyi Aç';

  @override
  String get staffCloseButton => 'Porteyi Kapat';

  @override
  String get staffPanelTitle => 'Porte Gösterimi';

  @override
  String get staffPanelDescription =>
      'Aynı MIDI notası ses egzersizi, piyano ve porte görünümü tarafından ortak kullanılır.';

  @override
  String get resolvedClefLabel => 'Çözülen anahtar';

  @override
  String get measureLabel => 'Ölçü';

  @override
  String get showPlayingNotesOnStaff => 'Çalan notaları portede göster';

  @override
  String get clefSelectionTitle => 'Anahtar seçimi';

  @override
  String get clefAuto => 'Otomatik';

  @override
  String get clefTreble => 'Sol Anahtarı';

  @override
  String get clefBass => 'Fa Anahtarı';

  @override
  String get clefAlto => 'Alto Anahtarı';

  @override
  String get clefTenor => 'Tenor Anahtarı';

  @override
  String get restLabel => 'Sus';

  @override
  String staffNoteSemantics(Object noteName) {
    return '$noteName notası';
  }

  @override
  String noteAccessibilityNatural(Object noteName, Object octave) {
    return '$noteName $octave';
  }

  @override
  String noteAccessibilityAccidental(
    Object noteName,
    Object accidental,
    Object octave,
  ) {
    return '$noteName $accidental $octave';
  }

  @override
  String pianoKeySemantics(Object noteName) {
    return '$noteName piyano tuşu';
  }

  @override
  String get accidentalSharpWord => 'diyez';

  @override
  String get accidentalFlatWord => 'bemol';

  @override
  String get staffQuizAppBarTitle => 'Portedeki Notayı Bul';

  @override
  String get staffQuizIntroTitle => 'Notayı Gör ve Adını Bul';

  @override
  String get staffQuizIntroDescription =>
      'Şimdilik sorular sol anahtarında bir oktavlık aralıkta üretiliyor.';

  @override
  String get staffQuizPromptTitle => 'Portedeki notayı seç';

  @override
  String get staffQuizPromptDescription =>
      'Bu egzersizde oktav bilgisi de değerlendirilir.';

  @override
  String get newQuestionButton => 'Yeni Soru';

  @override
  String get correctAnswerTitle => 'Doğru cevap';

  @override
  String get wrongAnswerTitle => 'Yanlış cevap';

  @override
  String get staffQuizCorrectMessage =>
      'Notayı doğru oktavla birlikte tanıdın.';

  @override
  String staffQuizWrongMessage(Object noteName) {
    return 'Doğru cevap $noteName olmalıydı.';
  }

  @override
  String get noteValueLessonAppBarTitle => 'Nota Değerlerini Öğren';

  @override
  String get noteValueLessonHeaderTitle => 'Temel Nota Süreleri';

  @override
  String get noteValueLessonHeaderDescription =>
      'Ön izlemeler 60 BPM üzerinden çalışır. Şimdilik süre vurgusu ve örnek ses birlikte kullanılıyor.';

  @override
  String noteValueBeatsLabel(Object beats) {
    return '4/4 içinde $beats vuruş';
  }

  @override
  String examplePattern(Object example) {
    return 'Örnek: $example';
  }

  @override
  String get listenShortButton => 'Dinle';

  @override
  String get noteValueWhole => 'Birlik nota';

  @override
  String get noteValueHalf => 'İkilik nota';

  @override
  String get noteValueQuarter => 'Dörtlük nota';

  @override
  String get noteValueEighth => 'Sekizlik nota';

  @override
  String get noteValueSixteenth => 'On altılık nota';

  @override
  String get noteValueDottedHalf => 'Noktalı ikilik';

  @override
  String get noteValueDottedQuarter => 'Noktalı dörtlük';

  @override
  String get noteValueDottedEighth => 'Noktalı sekizlik';

  @override
  String get noteValueExampleWhole => 'Ta-a-a-a';

  @override
  String get noteValueExampleHalf => 'Ta-a';

  @override
  String get noteValueExampleQuarter => 'Ta';

  @override
  String get noteValueExampleEighth => 'Ti-ti';

  @override
  String get melodyWritingAppBarTitle => 'Melodiyi Porteye Yaz';

  @override
  String get melodyWritingIntro =>
      'Bu ekran ileride sürükle-bırak nota yerleştirme için kullanılacak.';

  @override
  String get melodyWritingDescription =>
      'Planlanan araçlar: nota değeri seçimi, sus ekleme, yanlış notayı silme, sağa-sola taşıma ve ölçü bütünlüğü kontrolü.';

  @override
  String get freePianoAppBarTitle => 'Serbest Piyano';

  @override
  String get freePianoHeaderTitle => 'Serbest Tekrar Alanı';

  @override
  String get freePianoHeaderDescription =>
      'Bu alanı notaları denemek ve klavyedeki yerlerini ezberlemek için kullan. Gerçek egzersiz puanlaması burada çalışmaz.';

  @override
  String get productVisionShort =>
      'Özellikle konservatuvar ve müzik yetenek sınavlarına hazırlık için tasarlanmış, çok dilli ve ses odaklı kişisel müzik çalışma koçu.';
}
