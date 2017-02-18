
class Cratetom3u < Formula
  desc "cratetom3u is a tool to convert Serato .crate files to .m3u playlist files."
  homepage "https://github.com/MartinHH/CrateToM3U"
  url "https://github.com/MartinHH/CrateToM3U/releases/download/v0.2.1/io.github.martinhh.cratetom3u-0.2.1.jar"
  sha256 "58285719c1e80e079d73a68dd1ef5b94973d350e2d6d0696b9817a875e53e251"

  depends_on :java => "1.7+"

  resource "scallop" do
    url "https://repo1.maven.org/maven2/org/rogach/scallop_2.11/2.0.7/scallop_2.11-2.0.7.jar"
    sha256 "b37f2c05192b0fce5086c973c3ea47bbb95959c44a7903e341e1d7120fef70e8"
  end

  resource "scala-library" do
    url "https://repo1.maven.org/maven2/org/scala-lang/scala-library/2.11.8/scala-library-2.11.8.jar"
    sha256 "401e0f47d63221c811964534f2e480169f50919c804f728930ac6037eca4e5f6"
  end  

  resource "scala-reflect" do
    url "https://repo1.maven.org/maven2/org/scala-lang/scala-reflect/2.11.8/scala-reflect-2.11.8.jar"
    sha256 "29e081446a2a35de867411e06c6bc86863ac802401f8e8826f87723f668b4319"
  end   

  def install

    def install_resourcejar(name)
      resource(name).stage do
        libexec.install Dir["*.jar"]
      end
    end

    def create_launcher
      javaMain = "io.github.martinhh.sl.CrateToM3U"
      (bin/"cratetom3u").write <<-EOS.undent
        #!/bin/bash
        exec java -cp "#{libexec}/*" #{javaMain} "$@"
      EOS
    end

    install_resourcejar("scallop")
    install_resourcejar("scala-library")
    install_resourcejar("scala-reflect")

    libexec.install Dir["*"]

    create_launcher
  end

  test do
    # Test expected output when running cratetom3u with an empty input file
    (testpath/"Foo.crate").write("")
    output=shell_output("#{bin}/cratetom3u -f #{testpath}/Foo.crate Bar.m3u")
    expected="[cratetom3u]: No tracks found"
    assert(output.start_with? expected)
  end
end
