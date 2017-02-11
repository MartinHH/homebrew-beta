
class Cratetom3u < Formula
  desc "Cratetom3u is a tool to convert Serato .crate files to .m3u playlist files."
  homepage ""
  url "https://github.com/MartinHH/CrateToM3U/releases/download/v0.1.0/io.github.martinhh.cratetom3u-0.1.0.jar"
  sha256 "129c7e8772c07553928be24744eff65d274bd1d4d56268ae4ff81344aaceeecf"

  depends_on :java => "1.8+"

  resource "scallop" do
    url "https://repo1.maven.org/maven2/org/rogach/scallop_2.12/2.0.7/scallop_2.12-2.0.7.jar"
    sha256 "21b93ec50df3279899fd3756fe9f93bdbdb89f9bd39bc4e6d10eeb90b2caf545"
  end

  resource "scala-library" do
    url "https://repo1.maven.org/maven2/org/scala-lang/scala-library/2.12.1/scala-library-2.12.1.jar"
    sha256 "9dab78f3f205a038f48183b2391f8a593235f794d8129a479e06af3e6bc50ef8"
  end  

  resource "scala-reflect" do
    url "https://repo1.maven.org/maven2/org/scala-lang/scala-reflect/2.12.1/scala-reflect-2.12.1.jar"
    sha256 "d8a2b9d6d78c7457a40e394dc0c4fa6d6244acf0d156bbbcb311a9d497b85eec"
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
    output=shell_output("#{bin}/cratetom3u -i #{testpath}/Foo.crate -o Bar.m3u")
    expected="[CrateToM3U]: Error: no tracks found."
    assert(output.start_with? expected)
  end
end
