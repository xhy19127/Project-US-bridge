# -*- coding: utf-8 -*-
"""
Created on Sun Nov 29 20:45:42 2020

@author: XHY
"""


#%%
import plotly.graph_objects as go
import pandas as pd
from plotly.offline import plot

df=pd.read_csv(r"C:\Users\XHY\Desktop\STATE.csv")
code=list(df["CODE"])
cnt=list(df["COUNT"])
df = pd.DataFrame({'codes': code, 'bridges': cnt})

fig = go.Figure(data=go.Choropleth(
    locations=df['codes'],  
    z=df['bridges'].astype(float),  
    locationmode='USA-states',  
    hovertext=df['codes'],
    colorscale='Reds',  
    colorbar_title="Bridge Number", 
))

fig.update_layout(
    title_text='American Bridge Counts',  
    geo_scope='usa',  
)
fig.data[0].hovertemplate = '<b>City</b>: <b>%{hovertext}</b>' + \
                            '<br> <b>Bridge Number </b>: %{z}'
plot(fig, filename='MapA.html')
#%%
import plotly.graph_objects as go
import pandas as pd
from plotly.offline import plot

df=pd.read_csv(r"C:\Users\XHY\Desktop\STATE_COST.csv")
code=list(df["CODE"])
cnt=list(df["AVERAGE"])
df = pd.DataFrame({'codes': code, 'bridges': cnt})

fig = go.Figure(data=go.Choropleth(
    locations=df['codes'],  
    z=df['bridges'].astype(float),  
    locationmode='USA-states',  
    hovertext=df['codes'],
    colorscale='Reds',  
    colorbar_title="Bridge Average Cost",  
))

fig.update_layout(
    title_text='American Bridge Average Cost',  
    geo_scope='usa',  
)
fig.data[0].hovertemplate = '<b>City</b>: <b>%{hovertext}</b>' + \
                            '<br> <b>Bridge Average Cost </b>: %{z}'
plot(fig, filename='MapB.html')










