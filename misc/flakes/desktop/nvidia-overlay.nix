self: super: {
  linuxPackages = super.linuxPackages_zen.extend (self: super: {
    nvidiaPackages = {
      beta = super.nvidiaPackages.beta;
    };
  });
  linuxPackages_zen = self.linuxPackages;
}
