using Microsoft.AspNetCore.SignalR;

namespace PresentationWeb.Hubs;

public class PresentationHub : Hub
{
    private const int TotalSlides = 75;

    private static readonly int[] HiddenSlides = new[] { 10, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 45, 47, 49, 71 };

    private static int CurrentIndex = 1;

    public async Task SetSlide(int slide)
    {
        if (slide > 0 && slide <= TotalSlides)
        {
            CurrentIndex = slide;
        }

        await Clients.All.SendAsync("RefreshSlide", CurrentIndex);
    }

    public async override Task OnConnectedAsync()
    {
        await Clients.Caller.SendAsync("LoadSlides", new { current = CurrentIndex, count = TotalSlides, hidden = HiddenSlides });
        await base.OnConnectedAsync();
    }
}