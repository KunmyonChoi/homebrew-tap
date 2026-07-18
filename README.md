# KunmyonChoi/homebrew-tap

[Sizer](https://github.com/KunmyonChoi/sizer) 등 개인 프로젝트용 Homebrew tap.

## Sizer 설치

```bash
brew install KunmyonChoi/tap/sizer
```

소스에서 **로컬 빌드**되므로 Apple 개발자 등록/공증 없이도 **Gatekeeper 경고 없이** 설치됩니다.
(빌드에 Xcode가, 변환에 ffmpeg가 필요하며 ffmpeg는 자동 설치됩니다.)

설치 후 메뉴바 앱을 응용 프로그램에 연결·실행:

```bash
ln -sfn "$(brew --prefix)/opt/sizer/Sizer.app" /Applications/Sizer.app
open -a Sizer
```

최신 개발 버전으로 빌드하려면:

```bash
brew install --HEAD KunmyonChoi/tap/sizer
```
