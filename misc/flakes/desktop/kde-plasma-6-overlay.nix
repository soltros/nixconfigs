final: prev: {
  # Core KDE packages and frameworks
  kdePackages = prev.unstable.kdePackages;
  libsForQt5 = prev.unstable.libsForQt5;  # Some KDE packages might still depend on Qt5
  
  # All Qt6 related packages
  qt6 = prev.unstable.qt6;
  qt6Packages = prev.unstable.qt6Packages;
  
  # Ensure KDE Frameworks are from unstable
  kdeFrameworks = prev.unstable.kdeFrameworks;
  
  # Plasma specific packages
  plasma5Packages = prev.unstable.plasma5Packages;  # For transitional dependencies
  plasma6Packages = prev.unstable.plasma6Packages;
  
  # Additional KDE related packages
  kdiff3 = prev.unstable.kdiff3;
  kdeApplications = prev.unstable.kdeApplications;
  kdeGear = prev.unstable.kdeGear;
}
