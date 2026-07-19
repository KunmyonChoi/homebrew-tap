class Sizer < Formula
  desc "macOS menu-bar video & image compressor — auto-convert on drop"
  homepage "https://github.com/KunmyonChoi/sizer"
  url "https://github.com/KunmyonChoi/sizer/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "7993d16491b77e89f9683555f65450f1cd5300f062bcb8615d073528d9803f96"
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
  end

  def caveats
    <<~EOS
      Sizer는 메뉴바 앱입니다. 응용 프로그램에 연결한 뒤 실행하세요:
        ln -sfn #{opt_prefix}/Sizer.app /Applications/Sizer.app
        open -a Sizer

      소스에서 로컬 빌드되므로 Gatekeeper 경고가 없습니다.
      변환에 필요한 ffmpeg가 함께 설치됩니다.
      기본 폴더: ~/Movies/Sizer/{drop,output,processed,failed}
    EOS
  end

  test do
    assert_path_exists prefix/"Sizer.app/Contents/MacOS/Sizer"
  end
end
