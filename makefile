All: md5kernel.cu md5.cu main.cu
	nvcc -arch=sm_35 -o md5Gpu main.cu

clean:
	rm *.o
	rm md5
