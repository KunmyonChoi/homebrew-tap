class Sizer < Formula
  desc "macOS menu-bar video & image compressor — auto-convert on drop"
  homepage "https://github.com/KunmyonChoi/sizer"
  url "https://github.com/KunmyonChoi/sizer/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "c57e9778a1578ca492add6c79d9e45689d641edb0a5e184b4cd544a3c585d733"
  license "MIT"
  head "https://github.com/KunmyonChoi/sizer.git", branch: "main"

  depends_on xcode: :build
  depends_on "xcodegen" => :build
  depends_on "ffmpeg"
  depends_on macos: :ventura

  def install
    system "xcodegen", "generate"
    xcodebuild "-project", "Sizer.xcodeproj",
               "-scheme", "Sizer",
               "-configuration", "Release",
               "-derivedDataPath", "dd",
               "build"
    app = "dd/Build/Products/Release/Sizer.app"
    system "codesign", "--force", "--deep", "--sign", "-", app
    prefix.install app

    # 터미널에서 `sizer` 한 단어로 실행. 최초 실행 시 Applications에 링크를 만들어
    # Spotlight·런치패드에서도 보이게 한다(런타임이라 설치 샌드박스 영향을 받지 않는다).
    (bin/"sizer").write <<~SH
      #!/bin/bash
      app="#{opt_prefix}/Sizer.app"
      for dir in "/Applications" "$HOME/Applications"; do
        link="$dir/Sizer.app"
        if [ -e "$link" ] && [ ! -L "$link" ]; then
          break
        fi
        mkdir -p "$dir" 2>/dev/null
        ln -sfn "$app" "$link" 2>/dev/null && break
      done
      exec open "$app"
    SH
    (bin/"sizer").chmod 0555
  end

  def caveats
    <<~EOS
      메뉴바 앱이라 Homebrew(소스 빌드)는 /Applications 에 자동 등록하지 않습니다.
      설치 후 아래 한 줄이면 /Applications 에 등록되고 바로 실행됩니다(게이트키퍼 경고 없음):

        sizer

      한 번 실행하면 /Applications/Sizer.app 링크가 생겨 이후
      Spotlight·런치패드·Finder·`open -a Sizer` 로 열 수 있습니다. (메뉴바 앱이라 Dock 아이콘은 없습니다.)

      링크만 만들고 싶으면(실행 없이):
        ln -sfn $(brew --prefix)/opt/sizer/Sizer.app /Applications/Sizer.app

      변환에 필요한 ffmpeg가 함께 설치됩니다.
      기본 폴더: ~/Movies/Sizer/{drop,output,processed,failed}
    EOS
  end

  test do
    assert_path_exists prefix/"Sizer.app/Contents/MacOS/Sizer"
    assert_predicate bin/"sizer", :executable?
  end
end
