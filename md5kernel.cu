//This is our CUDA thread
//d_a is the word list array
//maxidx is the maximum index in the array (if there are more threads than words)
//v1 through v4 are the uint values of the correct md5 hash

__device__ void IncrementBruteGPU(unsigned char* ourBrute, uint charSetLen, uint bruteLength, uint incrementBy)
{
	int i = 0;
	while(incrementBy > 0 && i < bruteLength)
	{
		int add = incrementBy + ourBrute[i];
		ourBrute[i] = add % charSetLen;
		incrementBy = add / charSetLen;
		i++;
	}
}

__global__ void crack(uint numThreads, uint charSetLen, uint bruteLength, uint v1, uint v2, uint v3, uint v4)
{
	//compute our index number
    	uint idx = (blockIdx.x*blockDim.x + threadIdx.x);
	int totalLen = 0;
	int bruteStart = 0;

	unsigned char word[MAX_TOTAL];
	unsigned char ourBrute[MAX_BRUTE_LENGTH];

	int i = 0;

	for(i = 0; i < MAX_BRUTE_LENGTH; i++)
	{
		ourBrute[i] = cudaBrute[i];
	}
	
	i = 0;
	int ary_i = 0;
	unsigned char tmp = 0;
	while((tmp = cudaLeftSalt[ary_i]) != 0)
	{
		word[i] = tmp;
		i++; ary_i++;
	}
	bruteStart = i;
	i+= bruteLength;
	ary_i = 0;
	while((tmp = cudaRightSalt[ary_i]) != 0)
	{
		word[i] = tmp;
		i++; ary_i++;
	}
	totalLen = i;

	IncrementBruteGPU(ourBrute, charSetLen, bruteLength, idx);
	int timer = 0;
	for(timer = 0; timer < MD5_PER_KERNEL; timer++)
	{
		
		
		//Now, substitute the values into the string
		for(i = 0; i < bruteLength; i++)
		{
			word[i+bruteStart] = cudaCharSet[ourBrute[i]];
		}

		uint c1 = 0, c2 = 0, c3 = 0, c4 = 0;
		//get the md5 hash of the word
		md5_vfy(word,totalLen, &c1, &c2, &c3, &c4);
	
		//compare hash with correct hash
		if(c1 == v1 && c2 == v2 && c3 == v3 && c4 == v4)
		{
			//put the correct password in the first indexes of the array, right after the sentinal
			int j;
			for(j= 0; j < MAX_TOTAL; j++)
			{
				correctPass[j] = word[j];
			}
			correctPass[totalLen] = 0;
		}
		IncrementBruteGPU(ourBrute, charSetLen, bruteLength, numThreads);
	}
}

