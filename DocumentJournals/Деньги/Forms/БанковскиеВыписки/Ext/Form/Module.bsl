﻿
&НаСервере
Процедура УУ_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	НоваяКоманда = Команды.Добавить("КомандаОткрытьЗагрузкуВыписокИзКлиентБанка");
	НоваяКоманда.Действие = "ОткрытьЗагрузкуВыписокИзКлиентБанка";//Имя процедуры
	НоваяКоманда.Заголовок = "Настройка автозагрузки выписок через e-mail";
	НоваяКоманда.Отображение	= ОтображениеКнопки.КартинкаИТекст;
	НоваяКоманда.Картинка		= БиблиотекаКартинок.ОтправитьЭлектронноеПисьмо;
	НовыйЭлемент = Элементы.Добавить("ЭлементОткрытьЗагрузкуВыписокИзКлиентБанка",
	                                 Тип("КнопкаФормы"),
									 ЭтаФорма.Элементы.ГруппаКоманднаяПанель);
									
	НовыйЭлемент.ИмяКоманды = "КомандаОткрытьЗагрузкуВыписокИзКлиентБанка"; 
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЗагрузкуВыписокИзКлиентБанка(Команда)
	ОткрытьФорму("Обработка.сабЗагрузкаВыписокИзКлиентБанка.Форма");
КонецПроцедуры
