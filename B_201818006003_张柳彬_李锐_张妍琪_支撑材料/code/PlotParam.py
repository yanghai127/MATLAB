'''
Plot_prams 是绘图参数类，主要用于绘图细节控制，基于 matplotlib 传入一个 axis 对象进行控制
cut_white_border 是裁剪图片白色边界，主要用于保留图片主干内容
'''

import numpy as np
from PIL import Image
import matplotlib.pyplot as plt
import os,time

plt.rcParams['font.sans-serif'] = ['SimHei']
plt.rcParams['axes.unicode_minus'] = False
color = ['#4f81bd', '#c0504d', '#9bbb59', '#8064a2', '#4bacc6']

class Plot_parms(object):

    def __init__(self, ax):
        self.ax = ax

    def update_font(self, **kwargs):
        if kwargs.get('fontsize'):
            fontsize = kwargs['fontsize']
        else:
            fontsize = 12
        if kwargs.get('title'):
            self.ax.set_title(kwargs['title'], fontsize=fontsize + 2, fontweight=2)
        if kwargs.get('xlabel'):
            self.ax.set_xlabel(kwargs['xlabel'], fontsize=fontsize)
        if kwargs.get('ylabel'):
            self.ax.set_ylabel(kwargs['ylabel'], fontsize=fontsize)
        if kwargs.get('zlabel'):
            self.ax.set_zlabel(kwargs['zlabel'], fontsize=fontsize)
        if kwargs.get('powerlimits'):
            '''使用科学计数法'''
            self.ax.xaxis.get_major_formatter().set_powerlimits((0, 1))
            self.ax.yaxis.get_major_formatter().set_powerlimits((0, 1))

    def update_axis(self, **kwargs):
        if kwargs.get('xticks'):
            self.ax.set_xticks(kwargs['xticks'])  # rotation = 90 旋转量
        if kwargs.get('xlabels'):
            self.ax.set_xticklabels(kwargs['xlabels'])
        if kwargs.get('xticks_labels'):
            self.ax.set_xticks(kwargs['xticks_labels'][0])
            self.ax.set_xticklabels(kwargs['xticks_labels'][1])
        if kwargs.get('yticks'):
            self.ax.set_yticks(kwargs['yticks'])
            print(kwargs['yticks'])
        if kwargs.get('ylabels'):
            self.ax.set_yticklabels(kwargs['ylabels'])
        if kwargs.get('yticks_labels'):
            self.ax.set_yticks(kwargs['yticks_labels'][0])
            self.ax.set_yticklabels(kwargs['yticks_labels'][1])
        if kwargs.get('equal'):
            self.ax.axis('equal')
        if kwargs.get('move'):
            for axis in kwargs['move']:
                self.ax.spines[axis].set_position(('data', 0))
        if kwargs.get('hide'):
            if kwargs['hide'] == 'x':
                self.ax.set_xticks(())
            elif kwargs['hide'] == 'y':
                self.ax.set_yticks(())
            elif kwargs['hide'] == 'xy':
                self.ax.axis('off')

    def update_grid(self, **kwargs):
        if kwargs.get('grid'):
            if kwargs['grid'] == 'x':
                self.ax.xaxis.grid(linestyle='--',alpha = 0.5)
            elif kwargs['grid'] == 'y':
                self.ax.yaxis.grid(linestyle='--',alpha = 0.5)
            elif kwargs['grid'] == 'xy':
                self.ax.grid(linestyle='--',alpha = 0.5)
        if kwargs.get('xlim'):
            self.ax.set_xlim(*kwargs['xlim'])
        if kwargs.get('ylim'):
            self.ax.set_ylim(*kwargs['ylim'])

    def update_position(self, *kwargs):
        '''left,bottom,top,right'''
        for direction in kwargs:
            self.ax.spines[direction].set_visible(False)

    def save_fig(self, name):
        try:
            os.mkdir(os.getcwd() + '/../img')
        except FileExistsError:
            pass
        plt.savefig(f'{os.getcwd()}/../img/{name}.png', dpi=400, bbox_inches='tight')
        cut_white_border(f'{os.getcwd()}/../img/{name}.png')

    def update_legend(self, **kwargs):
        if kwargs.get('loc'):
            loc = kwargs['loc']
        else:
            loc = 'best'
        if kwargs.get('outside'):
            if kwargs['outside'] == 'top':
                bbox_to_anchor = (0., 1.02, 1., .102)
            else:
                bbox_to_anchor = (1.05, 1)
        else:
            bbox_to_anchor = None
        if kwargs.get('legend'):
            plt.legend(frameon=False, fancybox=True, loc=loc, ncol=1, bbox_to_anchor=bbox_to_anchor, borderaxespad=0)

    def style_default(self):
        self.update_grid(grid='xy')
        self.update_axis(hide='x')
        self.update_position('top','bottom','left','right')
        self.update_legend(legend = True)

    def run(self, **kwargs):
        self.ax.tick_params(axis='both', which='major', labelsize=11, direction='in')
        plt.tight_layout()
        if kwargs.get('name'):
            self.save_fig(kwargs['name'])
        else:
            plt.show()

def cut_white_border(filename):
    image = np.array(Image.open(filename))
    image_size = image.shape
    for i in range(image_size[0]):
        if (image[i] != 255).any():
            image = image[i:]
            break
    for i in range(len(image) - 1, 0, -1):
        if (image[i] != 255).any():
            image = image[:i + 1]
            break
    for i in range(image_size[1]):
        if (image[:, i] != 255).any():
            image = image[:, i:]
            break
    for i in range(len(image[0, :]) - 1, 0, -1):
        if (image[:, i] != 255).any():
            image = image[:, :i + 1]
            break
    Image.fromarray(image).save(filename)