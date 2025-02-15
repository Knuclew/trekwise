# 🌍 TrekWise: Akıllı Seyahat Asistanınız

<div align="center">
  <img src="TrekWise.png" alt="TrekWise Logo" width="200"/>
  <p><em>Türkiye'nin en kapsamlı seyahat rehberi</em></p>
</div>

## 📱 Uygulama Hakkında

TrekWise, seyahat planlamanızı kolaylaştıran ve ziyaret ettiğiniz yerler hakkında detaylı bilgiler sunan modern bir mobil uygulamadır. Yapay zeka destekli içerik üretimi sayesinde, gideceğiniz yerler hakkında güncel ve doğru bilgilere anında ulaşabilirsiniz.

### ✨ Özellikler

- 🔍 **Akıllı Arama**: Sadece Türkiye'de değil tüm dünyadaki yerlerle alakalı arama yapabilme
- 🤖 **Yapay Zeka Desteği**: Her yer için özelleştirilmiş, güncel bilgiler
- 🎯 **Detaylı Bilgiler**: 
  - Popüler turistik yerler
  - Artılar ve eksiler
  - Yerel tavsiyeler
  - Önemli ipuçları
- 🎨 **Modern Tasarım**: Kullanıcı dostu ve göz alıcı arayüz
- ⚡ **Hızlı Performans**: Anında yanıt veren arayüz

## 🚀 Kurulum

1. Depoyu klonlayın:
\`\`\`bash
git clone https://github.com/Knuclew/trekwise.git
\`\`\`

2. Bağımlılıkları yükleyin:
\`\`\`bash
cd trekwise
flutter pub get
\`\`\`

3. .env dosyasını oluşturun:
\`\`\`bash
cp .env.example .env
\`\`\`

4. .env dosyasına gerekli API anahtarlarını ekleyin:
\`\`\`
HUGGINGFACE_API_KEY=your_api_key_here
UNSPLASH_API_KEY=your_api_key_here
\`\`\`

5. Uygulamayı çalıştırın:
\`\`\`bash
flutter run
\`\`\`

## 🛠️ Teknik Detaylar

### Kullanılan Teknolojiler

- 📱 Flutter & Dart
- 🤖 HuggingFace API (Mixtral-8x7B-Instruct-v0.1)
- 🗺️ OpenStreetMap Nominatim API
- 🎨 Google Fonts
- 💾 Flutter Dotenv
- 🔍 Flutter TypeAhead

### Sistem Gereksinimleri

- Flutter SDK (>= 3.2.3)
- Dart SDK (>= 3.0.0)
- Android Studio / VS Code
- Android SDK / Xcode


## 🤝 Katkıda Bulunma

1. Bu depoyu fork edin
2. Yeni bir branch oluşturun (\`git checkout -b yeni-ozellik\`)
3. Değişikliklerinizi commit edin (\`git commit -am 'Yeni özellik eklendi'\`)
4. Branch'inizi push edin (\`git push origin yeni-ozellik\`)
5. Bir Pull Request oluşturun

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Daha fazla bilgi için [LICENSE](LICENSE) dosyasına bakın.

## 🙏 Teşekkürler

- HuggingFace ekibine muhteşem API'leri için
- OpenStreetMap topluluğuna harika harita verileri için
- Flutter ekibine mükemmel framework için

---

<div align="center">
  <p>TrekWise ile keşfetmenin tadını çıkarın! 🌟</p>
  <p>Made by ❤️ Knuclew</p>
</div> 