

# Java CountDownLatch 使用指南

CountDownLatch 是 Java 并发包 (`java.util.concurrent`) 中的一个同步辅助类，它允许一个或多个线程等待，直到在其他线程中执行的一组操作完成。

## 基本概念

CountDownLatch 通过一个计数器来实现，计数器的初始值由构造函数指定。当计数器值减到零时，所有等待的线程会被释放。

## 核心方法

1. **构造方法**:
   ```java
   CountDownLatch(int count)  // 初始化计数器
   ```

2. **主要方法**:
   - `await()` - 使当前线程等待，直到计数器减到零
   - `await(long timeout, TimeUnit unit)` - 带超时的等待
   - `countDown()` - 计数器减一
   - `getCount()` - 返回当前计数

## 使用场景

1. 启动多个线程并行执行任务，主线程等待所有任务完成
2. 多个线程等待某个事件发生后同时开始执行
3. 死锁检测等测试场景

## 基本使用示例

### 示例1：主线程等待工作线程完成

```java
import java.util.concurrent.CountDownLatch;

public class CountDownLatchExample1 {
    public static void main(String[] args) throws InterruptedException {
        final int THREAD_COUNT = 5;
        CountDownLatch latch = new CountDownLatch(THREAD_COUNT);
        
        for (int i = 0; i < THREAD_COUNT; i++) {
            new Thread(new Worker(latch), "Worker-" + i).start();
        }
        
        System.out.println("主线程等待所有工作线程完成...");
        latch.await();  // 主线程在此等待
        System.out.println("所有工作线程已完成，主线程继续执行");
    }
    
    static class Worker implements Runnable {
        private final CountDownLatch latch;
        
        public Worker(CountDownLatch latch) {
            this.latch = latch;
        }
        
        @Override
        public void run() {
            try {
                System.out.println(Thread.currentThread().getName() + " 正在工作...");
                Thread.sleep((long) (Math.random() * 2000));  // 模拟工作耗时
                System.out.println(Thread.currentThread().getName() + " 工作完成");
            } catch (InterruptedException e) {
                e.printStackTrace();
            } finally {
                latch.countDown();  // 任务完成，计数器减一
            }
        }
    }
}
```

### 示例2：多个线程同时开始执行

```java
import java.util.concurrent.CountDownLatch;

public class CountDownLatchExample2 {
    public static void main(String[] args) {
        final int THREAD_COUNT = 5;
        CountDownLatch startSignal = new CountDownLatch(1);
        
        for (int i = 0; i < THREAD_COUNT; i++) {
            new Thread(new Runner(startSignal), "Runner-" + i).start();
        }
        
        System.out.println("准备开始比赛...");
        try {
            Thread.sleep(2000);  // 模拟准备时间
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("比赛开始！");
        startSignal.countDown();  // 释放所有等待的线程
    }
    
    static class Runner implements Runnable {
        private final CountDownLatch startSignal;
        
        public Runner(CountDownLatch startSignal) {
            this.startSignal = startSignal;
        }
        
        @Override
        public void run() {
            try {
                System.out.println(Thread.currentThread().getName() + " 准备就绪，等待发令枪");
                startSignal.await();  // 等待开始信号
                System.out.println(Thread.currentThread().getName() + " 开始跑步");
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}
```

## 高级用法

### 结合多个 CountDownLatch

```java
import java.util.concurrent.CountDownLatch;

public class MultiStageProcess {
    public static void main(String[] args) throws InterruptedException {
        final int WORKER_COUNT = 3;
        
        // 准备阶段和完成阶段各一个Latch
        CountDownLatch prepareLatch = new CountDownLatch(WORKER_COUNT);
        CountDownLatch completeLatch = new CountDownLatch(WORKER_COUNT);
        
        for (int i = 0; i < WORKER_COUNT; i++) {
            new Thread(new MultiStageWorker(prepareLatch, completeLatch), "Worker-" + i).start();
        }
        
        System.out.println("主线程等待所有工作线程准备完成...");
        prepareLatch.await();
        System.out.println("所有工作线程已准备就绪，开始执行主要任务...");
        
        System.out.println("主线程等待所有工作线程完成任务...");
        completeLatch.await();
        System.out.println("所有工作已完成，主线程继续");
    }
    
    static class MultiStageWorker implements Runnable {
        private final CountDownLatch prepareLatch;
        private final CountDownLatch completeLatch;
        
        public MultiStageWorker(CountDownLatch prepareLatch, CountDownLatch completeLatch) {
            this.prepareLatch = prepareLatch;
            this.completeLatch = completeLatch;
        }
        
        @Override
        public void run() {
            try {
                // 准备阶段
                System.out.println(Thread.currentThread().getName() + " 正在准备...");
                Thread.sleep((long) (Math.random() * 1000));
                System.out.println(Thread.currentThread().getName() + " 准备完成");
                prepareLatch.countDown();
                
                // 等待所有线程准备完成
                prepareLatch.await();
                
                // 执行主要任务
                System.out.println(Thread.currentThread().getName() + " 开始执行主要任务...");
                Thread.sleep((long) (Math.random() * 2000));
                System.out.println(Thread.currentThread().getName() + " 任务完成");
                
            } catch (InterruptedException e) {
                e.printStackTrace();
            } finally {
                completeLatch.countDown();
            }
        }
    }
}
```

## 注意事项

1. **一次性使用**：CountDownLatch 的计数器不能被重置，如果需要重复使用，考虑使用 CyclicBarrier
2. **异常处理**：确保在 finally 块中调用 countDown()，避免线程异常导致计数器无法减到零
3. **死锁风险**：如果计数器永远无法减到零，等待的线程将永远阻塞
4. **性能考虑**：对于大量线程，await() 方法可能会引起性能问题

## 与 CyclicBarrier 的比较

| 特性       | CountDownLatch                 | CyclicBarrier              |
| ---------- | ------------------------------ | -------------------------- |
| 可重用性   | 不可重用                       | 可重用                     |
| 计数器方向 | 递减                           | 递增                       |
| 主要用途   | 一个或多个线程等待其他线程完成 | 多个线程相互等待到达屏障点 |
| 自动重置   | 无                             | 有                         |

CountDownLatch 是一个简单但强大的同步工具，合理使用可以简化多线程编程中的协调工作。

# Java CyclicBarrier 使用指南

CyclicBarrier 是 Java 并发包 (`java.util.concurrent`) 中的另一个同步辅助类，它允许一组线程互相等待，直到所有线程都到达某个屏障点（barrier point），然后这些线程才会继续执行。

## 基本概念

CyclicBarrier 通过一个计数器工作，当线程调用 await() 方法时会被阻塞，直到指定数量的线程都调用了 await() 方法，此时所有被阻塞的线程才会被释放继续执行。

## 核心特点

1. **循环使用**：与 CountDownLatch 不同，CyclicBarrier 可以被重置后重复使用
2. **屏障动作**：可以指定一个 Runnable 任务在所有线程到达屏障时执行
3. **多阶段同步**：适合将任务分成多个阶段，每个阶段都需要所有线程完成才能进入下一阶段

## 核心方法

1. **构造方法**:
   ```java
   CyclicBarrier(int parties)  // 指定参与线程数
   CyclicBarrier(int parties, Runnable barrierAction)  // 指定参与线程数和屏障动作
   ```

2. **主要方法**:
   - `await()` - 线程等待，直到所有线程都到达屏障
   - `await(long timeout, TimeUnit unit)` - 带超时的等待
   - `getNumberWaiting()` - 返回当前在屏障处等待的线程数
   - `getParties()` - 返回需要的线程数
   - `reset()` - 重置屏障

## 使用场景

1. 多线程分阶段处理任务
2. 并行计算，需要等待所有线程完成当前阶段
3. 多线程测试，确保所有线程同时开始执行

## 基本使用示例

### 示例1：基本屏障同步

```java
import java.util.concurrent.BrokenBarrierException;
import java.util.concurrent.CyclicBarrier;

public class CyclicBarrierExample1 {
    public static void main(String[] args) {
        final int THREAD_COUNT = 3;
        CyclicBarrier barrier = new CyclicBarrier(THREAD_COUNT, () -> {
            System.out.println("所有线程已到达屏障，继续执行");
        });
        
        for (int i = 0; i < THREAD_COUNT; i++) {
            new Thread(new Task(barrier), "Thread-" + i).start();
        }
    }
    
    static class Task implements Runnable {
        private final CyclicBarrier barrier;
        
        public Task(CyclicBarrier barrier) {
            this.barrier = barrier;
        }
        
        @Override
        public void run() {
            try {
                System.out.println(Thread.currentThread().getName() + " 开始第一阶段工作");
                Thread.sleep((long)(Math.random() * 2000));
                System.out.println(Thread.currentThread().getName() + " 到达屏障点，等待其他线程");
                barrier.await();
                
                System.out.println(Thread.currentThread().getName() + " 开始第二阶段工作");
                Thread.sleep((long)(Math.random() * 2000));
                System.out.println(Thread.currentThread().getName() + " 再次到达屏障点");
                barrier.await();
                
                System.out.println(Thread.currentThread().getName() + " 完成所有工作");
            } catch (InterruptedException | BrokenBarrierException e) {
                e.printStackTrace();
            }
        }
    }
}
```

### 示例2：带屏障动作

```java
import java.util.concurrent.CyclicBarrier;

public class CyclicBarrierExample2 {
    public static void main(String[] args) {
        final int THREAD_COUNT = 4;
        
        // 屏障动作会在所有线程到达屏障后，由最后一个到达屏障的线程执行
        CyclicBarrier barrier = new CyclicBarrier(THREAD_COUNT, () -> {
            System.out.println("\n所有线程已完成当前阶段，开始下一阶段\n");
        });
        
        for (int i = 0; i < THREAD_COUNT; i++) {
            new Thread(new StageTask(barrier), "Task-" + i).start();
        }
    }
    
    static class StageTask implements Runnable {
        private final CyclicBarrier barrier;
        
        public StageTask(CyclicBarrier barrier) {
            this.barrier = barrier;
        }
        
        @Override
        public void run() {
            try {
                // 第一阶段
                System.out.println(Thread.currentThread().getName() + " 执行第一阶段");
                Thread.sleep((long)(Math.random() * 1000));
                barrier.await();
                
                // 第二阶段
                System.out.println(Thread.currentThread().getName() + " 执行第二阶段");
                Thread.sleep((long)(Math.random() * 1000));
                barrier.await();
                
                // 第三阶段
                System.out.println(Thread.currentThread().getName() + " 执行第三阶段");
                Thread.sleep((long)(Math.random() * 1000));
                barrier.await();
                
                System.out.println(Thread.currentThread().getName() + " 完成所有阶段");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
```

## 高级用法

### 示例3：多阶段并行计算

```java
import java.util.concurrent.BrokenBarrierException;
import java.util.concurrent.CyclicBarrier;

public class ParallelComputation {
    private static final int SIZE = 5;
    private static int[][] matrix = new int[SIZE][SIZE];
    private static int[] rowResults = new int[SIZE];
    private static int finalResult;
    
    public static void main(String[] args) {
        // 第一阶段计算行和，第二阶段计算总和
        CyclicBarrier barrier = new CyclicBarrier(SIZE, () -> {
            System.out.println("开始计算最终结果");
            int sum = 0;
            for (int num : rowResults) {
                sum += num;
            }
            finalResult = sum;
            System.out.println("最终计算结果: " + finalResult);
        });
        
        // 初始化矩阵
        for (int i = 0; i < SIZE; i++) {
            for (int j = 0; j < SIZE; j++) {
                matrix[i][j] = (i + 1) * (j + 1);
            }
        }
        
        // 创建并启动工作线程
        for (int i = 0; i < SIZE; i++) {
            new Thread(new RowCalculator(i, barrier)).start();
        }
    }
    
    static class RowCalculator implements Runnable {
        private final int row;
        private final CyclicBarrier barrier;
        
        public RowCalculator(int row, CyclicBarrier barrier) {
            this.row = row;
            this.barrier = barrier;
        }
        
        @Override
        public void run() {
            try {
                // 计算行和
                int sum = 0;
                for (int j = 0; j < SIZE; j++) {
                    sum += matrix[row][j];
                }
                rowResults[row] = sum;
                System.out.println("行 " + row + " 计算结果: " + sum);
                
                // 等待所有行计算完成
                barrier.await();
            } catch (InterruptedException | BrokenBarrierException e) {
                e.printStackTrace();
            }
        }
    }
}
```

## 注意事项

1. **屏障异常**：如果线程在等待时被中断或超时，会抛出 BrokenBarrierException
2. **重置风险**：reset() 方法会中断所有等待的线程，需谨慎使用
3. **线程数量**：构造时指定的线程数必须与实际调用 await() 的线程数一致，否则会永远等待
4. **屏障动作**：屏障动作由最后一个到达屏障的线程执行，执行期间其他线程仍被阻塞
5. **性能考虑**：对于大量线程，await() 方法可能会引起性能问题

## 与 CountDownLatch 的对比

| 特性       | CyclicBarrier              | CountDownLatch                 |
| ---------- | -------------------------- | ------------------------------ |
| 可重用性   | 可重用                     | 不可重用                       |
| 计数器方向 | 递增                       | 递减                           |
| 主要用途   | 多个线程相互等待到达屏障点 | 一个或多个线程等待其他线程完成 |
| 自动重置   | 有                         | 无                             |
| 屏障动作   | 支持                       | 不支持                         |

CyclicBarrier 特别适合将复杂任务分解为多个阶段，并要求所有线程在每个阶段同步的场景。合理使用可以简化多阶段并行任务的处理。