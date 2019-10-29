
package app;

public class MaxMemory{
    public static void main(String[] args){
        System.out.println("Max Memory: "+Runtime.getRuntime().maxMemory() / 1024 / 1024);
    }
}