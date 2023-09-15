using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

public class PPSwaper : MonoBehaviour
{
    [SerializeField] private PostProcessVolume ppVolume;

    private List<PostProcessEffectSettings> _settings = new List<PostProcessEffectSettings>();

    private int _currentIndex = 0;

    private void Start()
    {
        _settings.Add(null);

        if (ppVolume.profile.TryGetSettings(out GrayscalePPSSettings grayscalePps)) _settings.Add(grayscalePps);
        if (ppVolume.profile.TryGetSettings(out ObraDinnPPSSettings obraDinnPps)) _settings.Add(obraDinnPps);
        if (ppVolume.profile.TryGetSettings(out PixelatePPSSettings pixelatePps)) _settings.Add(pixelatePps);
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.P)) Swap();
    }

    private void Swap()
    {
        if (_settings[_currentIndex]) _settings[_currentIndex].enabled = new BoolParameter {value = true};

        _currentIndex = (_currentIndex + 1) % _settings.Count;
        print(_currentIndex);

        if (_settings[_currentIndex]) _settings[_currentIndex].enabled = new BoolParameter {value = false};
    }
}