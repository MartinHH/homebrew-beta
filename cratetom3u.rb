
class Cratetom3u < Formula
  desc "cratetom3u is a tool to convert Serato .crate files to .m3u playlist files."
  homepage "https://github.com/MartinHH/CrateToM3U"
  license all_of: ["Apache-2.0", "MIT"]
  url "https://github.com/MartinHH/cratetom3u/releases/download/v0.2.4/cratetom3u-mac.zip"
  sha256 "081ce5a9fde7d1c2eeef3804c84797cc263acf8baa904ed249bf56dd310fc00a"

  def install
    bin.install "cratetom3u"
  end

  test do
    # Test expected output when running cratetom3u with an empty input file
    (testpath/"Foo.crate").write("")
    output=shell_output("#{bin}/cratetom3u -f #{testpath}/Foo.crate Bar.m3u")
    expected="[cratetom3u]: No tracks found"
    assert(output.start_with? expected)
  end
end
