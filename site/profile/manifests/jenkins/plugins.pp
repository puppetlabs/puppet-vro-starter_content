class profile::jenkins::plugins {

  jenkins::plugin { 'structs': }
  jenkins::plugin { 'workflow-step-api': }
  jenkins::plugin { 'workflow-api': }
  jenkins::plugin { 'promoted-builds': }
  jenkins::plugin { 'deployment-notification': }
  jenkins::plugin { 'puppet': }
  jenkins::plugin { 'ssh': }

}
