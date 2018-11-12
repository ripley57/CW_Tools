package dirwalkdemo;

import java.nio.file.Path;

public interface DirVisitor
{
    void visit(Path dir);
}