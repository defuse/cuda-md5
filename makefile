All: md5kernel.o md5.o main.cu
	nvcc -arch=sm_35 -o md5 md5kernel.o md5.o main.cu

md5kernel.o: md5kernel.cu
    nvcc -arch=sm_35 -c -o md5kernel.o

md5.o: md5.cu
    nvcc -arch=sm_35 -c -o md5kernel.o
    
clean:
	rm *.o
	rm md5
