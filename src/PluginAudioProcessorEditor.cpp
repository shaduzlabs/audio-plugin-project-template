/*
        ##########    Copyright (C) 2017 Vincenzo Pacella
        ##      ##    Distributed under MIT license, see file LICENSE
        ##      ##    or <http://opensource.org/licenses/MIT>
        ##      ##
##########      ############################################################# shaduzlabs.com #####*/

#include "PluginAudioProcessorEditor.h"
#include "PluginAudioProcessor.h"

//--------------------------------------------------------------------------------------------------

PluginAudioProcessorEditor::PluginAudioProcessorEditor(PluginAudioProcessor& p)
  : AudioProcessorEditor(&p), m_processor(p), m_gui(new GainGUI(p))
{
  setSize(150, 180);
  addAndMakeVisible(m_gui.get());
}

//--------------------------------------------------------------------------------------------------

void PluginAudioProcessorEditor::paint(Graphics& g)
{
}

//--------------------------------------------------------------------------------------------------

void PluginAudioProcessorEditor::resized()
{
}

//--------------------------------------------------------------------------------------------------
