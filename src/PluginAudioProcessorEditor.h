/*
        ##########    Copyright (C) 2017 Vincenzo Pacella
        ##      ##    Distributed under MIT license, see file LICENSE
        ##      ##    or <http://opensource.org/licenses/MIT>
        ##      ##
##########      ############################################################# shaduzlabs.com #####*/

#pragma once

#include "JuceHeader.h"
#include "PluginAudioProcessor.h"
#include "GainGUI.h"

//--------------------------------------------------------------------------------------------------

class PluginAudioProcessorEditor final : public AudioProcessorEditor
{
public:
  PluginAudioProcessorEditor(PluginAudioProcessor&);
  virtual ~PluginAudioProcessorEditor() = default;

  void paint(Graphics&) override;
  void resized() override;

private:
  PluginAudioProcessor& m_processor;
  std::unique_ptr<GainGUI> m_gui;

  JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR(PluginAudioProcessorEditor)
};

//--------------------------------------------------------------------------------------------------
