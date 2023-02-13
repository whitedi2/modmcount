﻿
&НаСервере
Процедура УУ_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	Группа = Элементы.Добавить(
	ЭтаФорма,
	Тип("ГруппаФормы"),
	ЭтаФорма.Элементы.ГруппаШапкаЛевая);
	
	Группа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	Группа.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	Группа.Отображение = ОтображениеОбычнойГруппы.Нет;
	
	Группа.Заголовок = "Параметры для учета (Упр.):";
	
	ПолеВвода = Элементы.Добавить("Контрагент", Тип("ПолеФормы"), Группа);
	ПолеВвода.Вид = ВидПоляФормы.ПолеВвода;
	ПолеВвода.ПутьКДанным = "Объект.Контрагент";
	
	ПолеВвода = Элементы.Добавить("Договор", Тип("ПолеФормы"), Группа);
	ПолеВвода.Вид = ВидПоляФормы.ПолеВвода;
	ПолеВвода.ПутьКДанным = "Объект.Договор";
	
КонецПроцедуры

&НаСервере
Процедура УУ_ПередЗаписьюНаСервереПосле(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ТекущийОбъект.ДополнительныеСвойства.Вставить("СинхронизироватьТЧСерииДокументаУУ",Истина);
КонецПроцедуры

