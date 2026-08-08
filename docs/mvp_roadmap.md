# MVP Yol Haritası

## Faz 1

### Kapsam

- Uygulama iskeleti
- Ana ekran
- Egzersiz kataloğu
- Flutter localization altyapısı
- Ortak MusicNote modeli
- MIDI ve frekans hesaplamaları

### Kabul Kriterleri

- Ana ekran kategoriler ve temel yönlendirme ile çalışır.
- Egzersizler ortak bir katalog modeli üzerinden tanımlanır.
- İngilizce ve Türkçe arayüz metinleri aynı kod tabanından yönetilir.
- Tek notalık hesaplar için MIDI, nota adı, oktav ve cent farkı güvenle hesaplanır.
- İlk aktif egzersizler uygulama içinde açılabilir.

### Testler

- Katalog bütün kategorileri döndürür.
- Tek Ses Tekrarı ve Portedeki Notayı Bul aktif görünür.
- MIDI ve frekans dönüşüm testleri geçer.
- Ana ekran küçük telefon boyutunda taşma üretmez.

## Faz 2

### Kapsam

- SoundFont tabanlı piyano sesi
- Etkileşimli piyano
- Oktav değiştirme
- Egzersiz notalarını piyanoda vurgulama

### Kabul Kriterleri

- Piyano paneli açılıp kapanabilir.
- Geçerli aralıktaki notalar tuşlandığında ses servisine iletilir.
- Oktav gezinmesi desteklenen aralığın dışına çıkmaz.
- Egzersiz notaları piyanoda vurgulanabilir.

### Testler

- Piyano paneli widget testleri
- Oktav sınırı testleri
- Ses servisi hata yönetimi testleri

## Faz 3

### Kapsam

- Porte gösterimi
- Sol ve Fa anahtarı
- Nota değerleri
- Piyano, porte ve ses senkronizasyonu

### Kabul Kriterleri

- Aynı MusicNote modeli portede doğru konumu üretir.
- Sol ve Fa anahtarı senaryoları desteklenir.
- Nota değerleri ölçü bütünlüğüyle doğrulanır.
- Piyano ve porte aynı hedef notayı senkron biçimde gösterebilir.

### Testler

- Porte renderer testleri
- Anahtar seçim testleri
- Ölçü doğrulama testleri

## Faz 4

### Kapsam

- Tek ses egzersizi
- Mikrofon kaydı
- Pitch tespiti
- Cent ve kararlılık analizi

### Kabul Kriterleri

- Mikrofon izni reddedildiğinde uygulama çökmemelidir.
- Tek ses egzersizi hedef sesi çalıp dinleme akışını başlatmalıdır.
- Pitch tespiti hedef nota, anlık nota, cent farkı ve kararlılık bilgisi üretmelidir.
- Geri bildirim pes, doğru veya tiz olarak açıklanmalıdır.

### Testler

- Mikrofon izin akışı testleri
- Pitch hesaplama ve sınıflandırma testleri
- Tek ses egzersizi widget testleri

## Faz 5

### Kapsam

- Çift, üç ve dört ses ayırma
- Melodi tekrarı
- Ritim tekrarı

### Kabul Kriterleri

- Çok sesli egzersizlerde aynı oturumda birden fazla hedef nota yönetilir.
- Melodi tekrarı perde ve zamanlama puanı üretir.
- Ritim tekrarı vuruş doğruluğunu ölçer.
- Eğitim modu ile sınav modu farklı geri bildirim davranışı gösterir.

### Testler

- Çok sesli soru üretim testleri
- Melodi karşılaştırma testleri
- Ritim motoru testleri

## Faz 6

### Kapsam

- Melodik dikte
- Nota yazma editörü
- Sınav simülasyonu
- Kişiselleştirilmiş çalışma programı

### Kabul Kriterleri

- Kullanıcı duyduğu melodiyi porteye yazabilir.
- Sınav simülasyonu belirlenen sırayla egzersizleri çalıştırır.
- Sonuç ekranı alt metrikleri ayrı ayrı raporlar.
- Kullanıcının zayıf olduğu alanlara göre öneri akışı oluşur.

### Testler

- Nota editörü davranış testleri
- Sınav akışı entegrasyon testleri
- Sonuç ve öneri motoru testleri
