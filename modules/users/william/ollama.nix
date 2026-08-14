{
  flake.modules.homeManager.william = {
    services.ollama.environmentVariables = {
      # HIP_VISIBLE_DEVICES = "0,1";
      # OLLAMA_LLM_LIBRARY = "cpu";
      OLLAMA_FLASH_ATTENTION = "1";
      OLLAMA_KEEP_ALIVE = "5m";
      OLLAMA_KV_CACHE_TYPE = "q8_0";
    };
  };
}
