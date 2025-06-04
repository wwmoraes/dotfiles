{
  programs.git-ps = {
    enable = true;
    hooks = {
      integrate_post_push = ./hooks/integrate_post_push.sh;
      integrate_verify = ./hooks/integrate_verify.sh;
      isolate_post_checkout = ./hooks/isolate_post_checkout.sh;
      isolate_post_cleanup = ./hooks/isolate_post_cleanup.sh;
      list_additional_information = ./hooks/list_additional_information.sh;
      request_review_post_sync = ./hooks/request_review_post_sync.sh;
    };
    settings = {
      branch = {
        push_to_remote = true;
        verify_isolation = true;
      };
      fetch.show_upstream_patches_after_fetch = true;
      integrate = {
        prompt_for_reassurance = false;
        pull_after_integrate = true;
        verify_isolation = true;
      };
      list = {
        add_extra_patch_info = true;
        extra_patch_info_length = 10;
        reverse_order = false;
        alternate_patch_series_colors = true;
        patch_background.alternate_color.RGB = [
          58
          58
          58
        ];
        patch_foreground.color.RGB = [
          248
          153
          95
        ];
        patch_index.color.RGB = [
          237
          199
          99
        ];
        patch_sha.color.RGB = [
          157
          208
          108
        ];
        patch_extra_info.color.RGB = [
          109
          202
          231
        ];
      };
      pull.show_list_post_pull = true;
      request_review.verify_isolation = true;
    };
  };
}
