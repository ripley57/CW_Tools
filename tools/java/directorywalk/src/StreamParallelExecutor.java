package dirwalkdemo;

import java.util.concurrent.ExecutionException;
import java.util.concurrent.ForkJoinPool;
import java.util.function.Function;
import java.util.stream.Stream;

public class StreamParallelExecutor {
    public static <T, R> R processParallel(Stream<T> stream, Function<Stream<T>, R> processor) {
    	return processParallel(stream, processor, Runtime.getRuntime().availableProcessors());        
    }
    
    public static <T, R> R processParallel(Stream<T> stream, Function<Stream<T>, R> processor, int numcpus) {
        Stream<T> parallelStream = stream.parallel();
        if (parallelStream.isParallel() && numcpus > 1) {
            ForkJoinPool f = new ForkJoinPool(numcpus);
            try {
                return f.submit(() -> processor.apply(parallelStream)).get();                
            } catch (InterruptedException | ExecutionException e) {
                throw new RuntimeException(e);
            } finally {
                f.shutdown();
            }
        } else {
            return processor.apply(parallelStream);
        }        
    }
}

