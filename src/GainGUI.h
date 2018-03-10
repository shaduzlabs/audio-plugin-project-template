/*
        ##########    Copyright (C) 2017 Vincenzo Pacella
        ##      ##    Distributed under MIT license, see file LICENSE
        ##      ##    or <http://opensource.org/licenses/MIT>
        ##      ##
##########      ############################################################# shaduzlabs.com #####*/

#pragma once

#include "JuceHeader.h"
#include "PluginAudioProcessor.h"

#include "ui/GraphicKnob.h"

//--------------------------------------------------------------------------------------------------

class GainGUI final : public Component, public Slider::Listener
{
public:
  GainGUI(PluginAudioProcessor& ap_);
  ~GainGUI();

  void sliderValueChanged(Slider* sliderThatWasMoved) override;

  void paint(Graphics& g) override;
  void resized() override;

private:
  PluginAudioProcessor& m_audioProcessor;
  Image m_knobStrip;
  Image m_knobStripHover;

  ScopedPointer<GraphicKnob> m_knob;
  ScopedPointer<Label> m_lblGain;
  Image m_backgroundImage;

  JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR(GainGUI)
};

//--------------------------------------------------------------------------------------------------
