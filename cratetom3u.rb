
class Cratetom3u < Formula
  desc "cratetom3u is a tool to convert Serato .crate files to .m3u playlist files."
  homepage "https://github.com/MartinHH/CrateToM3U"
  url "https://github.com/MartinHH/CrateToM3U/releases/download/v0.2.3/cratetom3u_2.13-0.2.3.jar"
  sha256 "811a1e3db26ce29fdbc4eae130aed45cbe2901fe454da817767f793c0f7ce3e5"

  depends_on "openjdk"

  resource "scallop" do
    url "https://repo1.maven.org/maven2/org/rogach/scallop_2.13/4.0.1/scallop_2.13-4.0.1.jar"
    sha256 "f47bf1ed84f89fe689f78a73c9acfead71ed353ed8ba1df63368f42b77a56540"
  end

  resource "scala-library" do
    url "https://repo1.maven.org/maven2/org/scala-lang/scala-library/2.13.4/scala-library-2.13.4.jar"
    sha256 "fbc1de27c46b46c4edaddb808f57afa2b0e016da12cb0abe4289ee69c42f2c8e"
  end

  def install

    def install_resourcejar(name)
      resource(name).stage do
        libexec.install Dir["*.jar"]
      end
    end

    def create_launcher
      javaMain = "io.github.martinhh.sl.CrateToM3U"
      (bin/"cratetom3u").write <<~EOS
        #!/bin/bash
        exec java -cp "#{libexec}/*" #{javaMain} "$@"
      EOS
    end

    install_resourcejar("scallop")
    install_resourcejar("scala-library")

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
