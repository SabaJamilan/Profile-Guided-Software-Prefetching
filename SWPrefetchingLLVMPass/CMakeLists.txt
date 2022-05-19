
add_llvm_library(SWPrefetchingLLVMPass MODULE
  SWPrefetchingLLVMPass.cpp
  PLUGIN_TOOL
  opt
  )
add_dependencies(SWPrefetchingLLVMPass intrinsics_gen)
