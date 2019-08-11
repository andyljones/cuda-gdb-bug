#include <stdio.h>

__global__ void increment(float* x) {
    x[threadIdx.x] = x[threadIdx.x] + 1;
}

__host__ int main(int argc, char** argv) {
    float *x;
    cudaMallocManaged(&x, 1*sizeof(float));
    x[0] = 1.f;

    increment<<<1, 1>>>(x);

    cudaDeviceSynchronize();
    printf("(good) x[0]: %f\n", x[0]);

    cudaFree(x);
    return 0;
}