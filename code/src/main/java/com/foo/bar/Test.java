package com.foo.bar;

import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Arrays;
import java.util.function.Consumer;

/**
 * @author 涂鼎 tuding27@gmail.com  QQ:200161
 * @version 0.1
 * @since 2022/5/7
 */
public class Test {

    public static void main(String[] args) throws IOException {
        Path p = Path.of("/usr/local/dev/Java Tool Kit");
        File f = p.toFile();
        File[] fs = f.listFiles((dir,name) -> name.startsWith("JDK"));
        Arrays.stream(fs).forEach(file -> System.out.println(file.getName()));
    }

}
