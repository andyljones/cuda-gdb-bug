#include <ATen/ATen.h> 

__global__ void increment(float* x) {
    x[threadIdx.x] = x[threadIdx.x] + 1;
}

__host__ int main(int argc, char** argv) {
    auto x = at::ones({1}, at::device(at::kCUDA));

    increment<<<1, 1>>>((float*) x.data_ptr());

    cudaDeviceSynchronize();
    printf("(bad) x[0]: %f\n", x[0].item<float>());
    return 0;
} 
