# Özellik Matrisi

## Duy ve Söyle

| Özellik | Açıklama | MVP | Mikrofon | Piyano | Porte | Ritim Motoru | Zorluk | Bağımlılıklar |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Tek Ses Tekrarı | Tek bir hedef sesi duyup aynı notayı sesle tekrar etme çalışması. | Evet | Evet | Evet | Evet | Hayır | Başlangıç | MusicNote modeli, frekans hesaplaması, temel egzersiz akışı |
| Çift Ses Ayırma | Arka arkaya veya birlikte verilen iki sesi tanıma ve söyleme çalışması. | Hayır | Evet | Evet | Evet | Hayır | Orta | Tek Ses Tekrarı, pitch analizi, çoklu nota vurgusu |
| Üç Ses Ayırma | Üç sesli yapıları tek tek duymaya ve söylemeye hazırlayan çalışma. | Hayır | Evet | Evet | Evet | Hayır | İleri | Çift Ses Ayırma, akor vurgusu, görsel senkronizasyon |
| Dört Ses Ayırma | Dört sesli akorları analiz etme ve sesleri ayıklama çalışması. | Hayır | Evet | Evet | Evet | Hayır | İleri | Üç Ses Ayırma, akor yapıları, gelişmiş puanlama |
| Melodi Tekrarı | Kısa melodiyi dinleyip sesle aynı sırada tekrar etme çalışması. | Hayır | Evet | Evet | Evet | Kısmen | Orta | Pitch analizi, nota dizisi oynatma, zamanlama puanı |
| Aralık Söyleme | Verilen başlangıç notasından hedef aralığı doğru söyleme çalışması. | Hayır | Evet | Evet | Evet | Hayır | Orta | Tek Ses Tekrarı, aralık hesapları, yönlendirmeli geri bildirim |

## Duy ve Vur

| Özellik | Açıklama | MVP | Mikrofon | Piyano | Porte | Ritim Motoru | Zorluk | Bağımlılıklar |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Ritim Tekrarı | Duyulan ritmi aynı akışla geri vurma çalışması. | Hayır | Hayır | Hayır | Evet | Evet | Başlangıç | Metronom, süre modeli, ritim puanlaması |
| Ritmi Tamamla | Eksik bırakılan ritmik boşluğu doğru değerlerle tamamlama görevi. | Hayır | Hayır | Hayır | Evet | Evet | Orta | Nota değerleri, ölçü doğrulama, porte gösterimi |
| Hatalı Ritmi Bul | Doğru örnekle bozuk ritim arasında farkı ayırt etme çalışması. | Hayır | Hayır | Hayır | Evet | Evet | Orta | Ritim motoru, karşılaştırmalı oynatma |
| Mikrofonla Alkış Tekrarı | Ritmi alkış veya vuruş sesiyle mikrofondan tekrar etme çalışması. | Hayır | Evet | Hayır | Evet | Evet | Orta | Gecikme kalibrasyonu, mikrofon kaydı, transient analizi |

## Duy ve Yaz

| Özellik | Açıklama | MVP | Mikrofon | Piyano | Porte | Ritim Motoru | Zorluk | Bağımlılıklar |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Tek Sesi Porteye Yerleştir | Duyulan tek notayı doğru porte konumuna yerleştirme çalışması. | Hayır | Hayır | Evet | Evet | Hayır | Başlangıç | MusicNote modeli, porte konumu, seçim arayüzü |
| Ritmi Porteye Yaz | Duyulan ritmi notasyon olarak ölçüye yerleştirme görevi. | Hayır | Hayır | Hayır | Evet | Evet | Orta | Nota değerleri, ölçü doğrulama, editör altyapısı |
| Melodik Dikte | Duyulan kısa melodiyi notalar ve süreleriyle porteye yazma görevi. | Hayır | Hayır | Evet | Evet | Evet | İleri | Nota editörü, ses oynatma, doğrulama motoru |
| Akoru Porteye Yerleştir | Birlikte duyulan sesleri akor olarak porteye yazma görevi. | Hayır | Hayır | Evet | Evet | Hayır | İleri | Çoklu nota seçimi, dikey notasyon, akor modeli |

## Oku ve Uygula

| Özellik | Açıklama | MVP | Mikrofon | Piyano | Porte | Ritim Motoru | Zorluk | Bağımlılıklar |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Portedeki Notayı Bul | Portede görülen tek notayı adı ve oktavıyla tanıma çalışması. | Evet | Hayır | Hayır | Evet | Hayır | Başlangıç | MusicNote modeli, porte gösterimi, soru üretimi |
| Portedeki Notayı Söyle | Portede görülen notayı sesle doğru perdeye söyleme çalışması. | Hayır | Evet | Evet | Evet | Hayır | Orta | Portedeki Notayı Bul, pitch analizi |
| Piyanoda Çal | Portede görülen notayı ekrandaki piyanoda doğru tuşla çalma çalışması. | Hayır | Hayır | Evet | Evet | Hayır | Başlangıç | Etkileşimli piyano, MusicNote eşleştirmesi |
| Deşifre | Kısa notasyon dizisini anlık okuyup uygulama çalışması. | Hayır | Evet | Evet | Evet | Evet | İleri | Nota dizisi oynatma, zamanlama, pitch analizi |
| Solfej | Yazılı melodiyi ritim ve perde doğruluğuyla seslendirme çalışması. | Hayır | Evet | Evet | Evet | Evet | İleri | Deşifre, sözlü geribildirim, tempo takibi |

## Sınav Simülasyonu

| Özellik | Açıklama | MVP | Mikrofon | Piyano | Porte | Ritim Motoru | Zorluk | Bağımlılıklar |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Başlangıç Seviye Sınavı | Temel işitme ve nota okuma görevlerini tek oturumda toplar. | Hayır | Kısmen | Evet | Evet | Kısmen | Başlangıç | Temel egzersizlerin puanlanabilir sürümleri |
| Orta Seviye Sınavı | Daha uzun işitme ve ritim görevlerinden oluşan karma sınav akışı. | Hayır | Kısmen | Evet | Evet | Evet | Orta | Tek Ses, ritim, nota okuma ve zaman yönetimi |
| İleri Seviye Sınavı | Çok sesli, melodik ve ritmik görevleri birlikte puanlayan sınav. | Hayır | Evet | Evet | Evet | Evet | İleri | Çok ses, dikte ve ayrıntılı skor motoru |
| Özel Sınav Oluşturma | Öğretmenin veya öğrencinin kendi sınav akışını kurmasını sağlar. | Hayır | Kısmen | Evet | Evet | Evet | İleri | Sınav motoru, egzersiz seçici, sonuç kayıtları |

## Serbest Çalışma

| Özellik | Açıklama | MVP | Mikrofon | Piyano | Porte | Ritim Motoru | Zorluk | Bağımlılıklar |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Piyano | Etkileşimli klavye üzerinde serbest nota denemesi yapma alanı. | Evet | Hayır | Evet | Hayır | Hayır | Başlangıç | SoundFont, etkileşimli piyano, oktav kontrolü |
| Porte | Portede notaları görme ve yerleştirme odaklı serbest çalışma alanı. | Hayır | Hayır | Hayır | Evet | Hayır | Başlangıç | Porte renderer, temel editör altyapısı |
| Metronom | Sabit tempo ile bireysel çalışma yürütmeyi sağlar. | Hayır | Hayır | Hayır | Hayır | Evet | Başlangıç | Ses oynatma, tempo kontrolü |
| Tuner | Kullanıcının ses yüksekliğini anlık takip ederek perde doğruluğu gösterir. | Hayır | Evet | Hayır | Hayır | Hayır | Orta | Mikrofon kaydı, pitch tespiti, kararlılık analizi |
| Ses Aralığı Testi | Kullanıcının en rahat alt ve üst ses sınırını ölçer. | Hayır | Evet | Evet | Evet | Hayır | Orta | Pitch analizi, egzersiz akışı, sonuç kaydı |
